from constants import *
from exceptions import *
from descriptors import *
import datetime
import bson
import time

def object_hook_handler(obj):
    object_data = obj.get('__OBJ__')
    if object_data:
        object_type, object_data = object_data
        if object_type == 'OID':
            return bson.ObjectId(object_id)
        elif object_type == 'DATE':
            return datetime.datetime.fromtimestamp(object_data)
    return obj

def json_default(obj):
    if isinstance(obj, bson.ObjectId):
        return {'__OBJ__': ['OID', str(obj)]}
    elif isinstance(obj, datetime.datetime):
        return {'__OBJ__': ['DATE', time.mktime(obj.timetuple()) + (obj.microsecond / 1000000.)]}
    return obj
