-- <SQL name="create.table.userinfo">
CREATE TABLE [userinfo] (
[id] INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT,
[f_type] INTEGER  NOT NULL,
[f_key] TEXT  NOT NULL,
[f_value] TEXT  NULL
);
-- </SQL>

-- <SQL name="create.index.userinfo">
CREATE UNIQUE INDEX [index_userinfo] ON [userinfo](
[f_type]  DESC,
[f_key]  DESC
);
-- </SQL>

-- <SQL name="select.userinfo.type">
SELECT *
  FROM userinfo where f_type = ?
-- </SQL>

  -- <SQL name="select.userinfo.key">
SELECT f_value
  FROM userinfo where f_type = ? and f_key = ?
-- </SQL>
  
-- <SQL name="insert.userinfo">  
  INSERT INTO userinfo(
             f_type, f_key, f_value)
    VALUES ( ?, ?, ?)
-- </SQL>

-- <SQL name="update.userinfo">  
  UPDATE userinfo set f_type=?,f_key=?,f_value=? where id=?
-- </SQL>
 -- <SQL name="delete.userinfo">  
  DELETE FROM userinfo 
-- </SQL>   