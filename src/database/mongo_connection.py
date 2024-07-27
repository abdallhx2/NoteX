# from pymongo import MongoClient

# def get_database():
#     # استبدل القيم التالية بقيمك الخاصة
#     CONNECTION_STRING = "mongodb+srv://3bdallhx2:<password>@cluster0.yg82qxm.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"
    
#     # إنشاء عميل MongoDB
#     client = MongoClient(CONNECTION_STRING)
    
#     # إنشاء قاعدة البيانات
#     return client['test_db']

# if __name__ == "__main__":
#     # اختبار الاتصال بقاعدة البيانات
#     db = get_database()
#     print("Connected to the database:", db.name)



from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

uri = "mongodb+srv://3bdallhx2:<password>@cluster0.yg82qxm.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0"

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))

# Send a ping to confirm a successful connection
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)