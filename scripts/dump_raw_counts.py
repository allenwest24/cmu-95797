# scripts/dump_raw_counts.py

import duckdb

def main():
    # Connect to the database
    con = duckdb.connect('main.db')

    # List of tables to get counts for
    tables = [
        'bike_data',
        'central_park_weather',
        'fhv_bases'
    ]

    # Write the counts to a file
    with open('answers/raw_counts.txt', 'w') as f:
        # Get the count for each table
        for table in tables:
            count = con.execute(f'SELECT COUNT(*) FROM {table}').fetchone()[0]
            f.write(f'{table}: {count}\n')
            print(f'{table}: {count}')

if __name__ == "__main__":
    main()
