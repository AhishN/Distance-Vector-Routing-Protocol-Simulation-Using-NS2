// Save file to folder
foreach ($m->mFiles as $key => $file) {
        $dir = 'attachments';
        //if (!file_exists($dir)) {
         //       mkdir($dir);
       // }
        //  Save content to file
        $path = "gs://turnkey-citadel-195504.appspot.com".'/'.basename($file['name']);
        file_put_contents($path, $file['content']);
}

//echo "<img src='gs://turnkey-citadel-195504.appspot.com/attachments/".basename($file['name'])."'/>";


        $dsn = getenv('MYSQL_DSN');
        $user = getenv('MYSQL_USER');
        $password = getenv('MYSQL_PASSWORD');

        if(!isset($dsn,$user) || false === $password){
                throw new Exception("Error Processing Request", 1);
        }


        $db = new PDO($dsn,$user,$password);
        if($db == null){
                echo "cant connect";
        }
        $name = $file['name'];
        $statement = $db->prepare("insert into data values('$name','$path')");
        if($statement == null){
                echo "Cant create statement";
        }
        $statement->execute() or die("Cant execute query");