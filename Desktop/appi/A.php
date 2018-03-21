<?php
		//Conecting to database
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
		
		if($mFiles != null) {
			// Save file to folder
			foreach ($m->mFiles as $key => $file) {
				$dir = 'attachments';
				//if (!file_exists($dir)) {
				 //       mkdir($dir);
			   // }
				//  Save content to file
				$name = basename($file['name']);
				$path = "gs://turnkey-citadel-195504.appspot.com/".'/'.$name;
				file_put_contents($path, $file['content']);
				
				$statement = $db->prepare("insert into data values('$name','$path')");
				if($statement == null){
						echo "Cant create statement";
				}
				$statement->execute() or die("Cant execute query");
			}
		}
		
?>