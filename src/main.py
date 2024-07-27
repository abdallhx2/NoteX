from database.mongo_connection import get_database

def main():
    db = get_database()
    print("Connected to the database:", db.name)
    # أضف المزيد من الأكواد الخاصة بك هنا

if __name__ == "__main__":
    main()
