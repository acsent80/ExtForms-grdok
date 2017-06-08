var fso = new ActiveXObject("Scripting.FileSystemObject");

var lib = new Object;
eval(fso.OpenTextFile("update-db-1c.js", 1).ReadAll());
//log(lib.v8cexe);

v8cexe     = "C:/1CData/8.3.9.2170_x64/bin/1cv8c.exe";
v8exe      = "C:/1CData/8.3.9.2170_x64/bin/1cv8.exe";
server     = "gr-rphost-01";
sqlServer  = "gr-sql";
db         = "ERP_TEST";
cf         = "C:/1CData/release/1Cv8_2017-05-26.cf";
logFile    = "N:/gr/dok/Users/AppData/sitnikov.a/1CData/update.log";
unlockCode = "123321";
backupFile = "E:\\temp\\" + db + ".bak";

run();
