
An API (Application Programming Interface) allows other software like frontend apps or mobiles to communicate with backend service over http.

Restful APIs respond to


| HTTP Method | Purpose       |
| ----------- | ------------- |
| GET         | Retrieve data |
| POST        | Create data   |
| PUT/PARCH   | Update data   |
| DELETE      | Delete data   |
All data is send and received as JSON

## Connecting to database (php)

```php
$servername = "localhost"; $username = "root"; $password = ""; $database = "mydatabase"; 
// Create connection 
$conn = mysqli_connect($servername, $username, $password, $database); 
// Check connection 
if (!$conn) { die("Connection failed: " . mysqli_connect_error()); }
echo "Connected successfully";
// Your database operations go here 
// Close the connection 
mysqli_close($conn);
```