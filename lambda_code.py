import json
import logging
import boto3
from decimal import Decimal
from botocore.exceptions import ClientError

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('dishes')

dish_path = '/dish'
dishes_path = '/dishes'

def lambda_handler(event, context):
        
    logger.info('API event: {}'.format(event))
    
    response = None
    
    try: 
        http_method = event.get('httpMethod')
        path = event.get('path')
        
        if http_method == 'GET' and path == dishes_path:
            response = get_all_dishes()
            
        elif http_method == 'GET' and path == dish_path:
            dish_id = event['queryStringParameters']['dish_id']
            response = get_dish(dish_id)
            
        elif http_method == 'POST' and path == dish_path:
            body = json.loads(event['body'])
            response = save_dish(body)
            
        elif http_method == 'PATCH' and path == dish_path:
            body = json.loads(event['body'])
            response = update_dish(body['dish_id'], body['update_key'], body['update_value'])
            
        elif http_method == 'DELETE':
            body = json.loads(event['body'])
            response = delete_dish(body['dish_id'])
            
        else:
            response = generate_response(404, 'Resource Not Found')
            
    except ClientError as e:
        logger.error('Error: {}'.format(e))
        response = generate_response(404, e.response['Error']['Message'])
        
    return response
        
def get_dish(dish_id):
    try:
        response = table.get_item(Key={'dish_id': dish_id})
        item = response['Item']
        logger.info('GET item: {}'.format(item))
        return generate_response(200, item)
    except ClientError as e:
        logger.error('Error: {}'.format(e))
        return generate_response(404, e.response['Error']['Message'])
    
def get_all_dishes():
    try:
        scan_params = {
            'TableName': table.name
        }
        items = recursive_scan(scan_params, [])
        logger.info('GET ALL items: {}'.format(items))
        return generate_response(200, items)
    except ClientError as e:
        logger.error('Error: {}'.format(e))
        return generate_response(404, e.response['Error']['Message'])
    
def recursive_scan(scan_params, items):
    response = table.scan(**scan_params)
    items += response['Items']
    if 'LastEvaluatedKey' in response:
        scan_params['ExclusiveStartKey'] = response['LastEvaluatedKey']
        recursive_scan(scan_params, items)
    return items

def save_dish(item):
    try:
        table.put_item(Item=item)
        logger.info('POST item: {}'.format(item))
        body = {
            'Operation': 'SAVE',
            'Message': 'SUCCESS',
            'Item': item
        }
        return generate_response(200, body)
    except ClientError as e:
        logger.error('Error: {}'.format(e))
        return generate_response(404, e.response['Error']['Message'])
    
def update_dish(dish_id, update_key, update_value):
    try:
        response = table.update_item(
            Key={'dish_id': dish_id},
            UpdateExpression=f'SET {update_key} = :value',
            ExpressionAttributeValues={':value': update_value},
            ReturnValues='UPDATED_NEW'
        )
        logger.info('UPDATE item: {}'.format(response))
        body = {
            'Operation': 'UPDATE',
            'Message': 'SUCCESS',
            'Item': response
        }
        return generate_response(200, response)
    except ClientError as e:
        logger.error('Error: {}'.format(e))
        return generate_response(404, e.response['Error']['Message'])
    
def delete_dish(dish_id):
    try:
        response = table.delete_item(
            Key={'dish_id': dish_id},
            ReturnValues='ALL_OLD'
        )
        logger.info('DELETE item: {}'.format(response))
        body = {
            'Operation': 'DELETE',
            'Message': 'SUCCESS',
            'Item': response
        }
        return generate_response(200, body)
    except ClientError as e:
        logger.error('Error: {}'.format(e))
        return generate_response(404, e.response['Error']['Message'])

class DecimalEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, Decimal):
            # Check if it's an int or a float
            if obj % 1 == 0:
                return int(obj)
            else:
                return float(obj)
        # Let the base class default method raise the TypeError
        return super(DecimalEncoder, self).default(obj)
        
def generate_response(status_code, body):
    return {
        'statusCode': status_code,
        'headers': {
            'Content-Type': 'application/json',
        },
        'body': json.dumps(body, cls=DecimalEncoder)
    }