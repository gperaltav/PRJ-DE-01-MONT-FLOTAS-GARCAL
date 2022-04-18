const pgtools = require("pgtools");
const config = {
  user: "postgres",
  host: "localhost",
  password: "some+random?password!",
  port: 5432
};


//-----------------------------------------------------------
const createTableText = `
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE TEMP TABLE IF NOT EXISTS users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  data JSONB
);
`
// create our temp table
await client.query(createTableText)


//-----------------------------------------------------------
// INSERT INTO TABLE_NAME  
// (column1,  
// column2,  
// column3, ……columnN)   
// VALUES (value1, value2, value3, ….. valueN);

const newUser = { email: 'brian.m.carlson@gmail.com' }
// create a new user
await client.query('INSERT INTO users(data) VALUES($1)', [newUser])

//-----------------------------------------------------------
// SELECT select_list 
// FROM table_name;
const { rows } = await client.query('SELECT * FROM users')
console.log(rows)
/*
output:
[{
  id: 'd70195fd-608e-42dc-b0f5-eee975a621e9',
  data: { email: 'brian.m.carlson@gmail.com' }
}]
*/


//-----------------------------------------------------------
// UPDATE table_name   
// SET column1 = value1,  
// column2 = value2....,  
// columnN = valueN   
// WHERE
// condition;  


//-----------------------------------------------------------
// DELETE FROM table_name   
// WHERE [condition];   

