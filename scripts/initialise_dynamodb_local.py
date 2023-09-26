import os
import boto3
import hcl2

def create_dynamodb_table(endpoint, table_name, attribute_definitions, key_schema, provisioned_throughput):
    dynamodb = boto3.resource('dynamodb', endpoint_url=endpoint, region_name="eu-west-2", aws_access_key_id="sample", aws_secret_access_key="sample")

    dynamodb.create_table(
        TableName=table_name,
        AttributeDefinitions=attribute_definitions,
        KeySchema=key_schema,
        ProvisionedThroughput=provisioned_throughput
    )

def main():
    with open(os.environ['TERRAFORM_PATH'], 'r') as f:
        dynamodb_module_config = hcl2.load(f)

    app_name = os.environ['APP_NAME']

    for resource in dynamodb_module_config['resource']:
        if 'aws_dynamodb_table' in resource:
            for table_key, table_config in resource['aws_dynamodb_table'].items():
                table_name_template = table_config['name']
                table_name = table_name_template.replace("${var.app_name}", app_name)

                # Extracting attribute definitions for the primary key only
                attribute_definitions = [{'AttributeName': table_config['hash_key'], 'AttributeType': [attr['type'] for attr in table_config['attribute'] if attr['name'] == table_config['hash_key']][0]}]

                # Extracting key schema
                key_schema = [{'AttributeName': table_config['hash_key'], 'KeyType': 'HASH'}]

                provisioned_throughput = {
                    'ReadCapacityUnits': table_config.get('read_capacity', 5),
                    'WriteCapacityUnits': table_config.get('write_capacity', 5)
                }

                print(f"Creating Table: {table_name}")

                create_dynamodb_table(os.environ['DYNAMODB_ENDPOINT'], table_name, attribute_definitions, key_schema, provisioned_throughput)

if __name__ == '__main__':
    main()
