//run with cscript
//auth via NTLM
var v8cexe     = "C:/1CData/8.3.9.2170_x64/bin/1cv8c.exe";
var v8exe      = "C:/1CData/8.3.9.2170_x64/bin/1cv8.exe";
var server     = "server1c";
var sqlServer  = "sql";
var db         = "DBName";
var cf         = "1Cv8.cf";
var logFile    = "update.log";
var unlockCode = "123321";
var backupFile = "E:\\temp\\" + db + ".bak";

var WshShell = WScript.CreateObject('WScript.Shell');
var fso  = new ActiveXObject("Scripting.FileSystemObject");

function GetDate() {

    var date = new Date;
    return date;

}

function log(str) {
    WScript.Echo(str);
    
    var logFile = fso.OpenTextFile("debug.log", 8, true); 
    logFile.WriteLine(str);     
    logFile.close();
}

function Connect1C() {
    
    var srvAddr  = "tcp://" + server + ":1540";
    var mainPort = 1541;

    var v8com = new ActiveXObject("V83.COMConnector");
    var serverAgent = v8com.ConnectAgent(srvAddr);

    var clusters = serverAgent.GetClusters().toArray();
    var cluster = undefined;
    for (var i in clusters) {
	    cluster = clusters[i];
        if (cluster.MainPort === mainPort) break;
    }

    if (!cluster) {
        log("Cluster not found");
        return undefined;
    }    

    serverAgent.Authenticate(cluster, "", "");

    var workingProcesses = serverAgent.GetWorkingProcesses(cluster).toArray();
    for (var i in workingProcesses) {

	    var workingProcess = workingProcesses[i];
        if (workingProcess.Running !== 1) continue;

        var addr = "tcp://" + workingProcess.HostName + ":" + workingProcess.MainPort;
        var cwp = v8com.ConnectWorkingProcess(addr);
        cwp.AddAuthentication("", "");
        
        var infoBases = cwp.GetInfoBases().toArray();
        for (var j in infoBases) {
            var infoBase = infoBases[j];
            if (infoBase.Name === db) {
                
                return {
                    "serverAgent": serverAgent, 
                    "cluster": cluster,
                    "cwp": cwp, 
                    "infoBase": infoBase
                };
            }    
        }    

    }

}

function ChangeIBParams1C(sessionsDenied) {

    log("ChangeIBParams1C: " + GetDate());

    var params = Connect1C();
    if (params) {

        var infoBase = params.infoBase;
        var cwp = params.cwp;

        infoBase.SessionsDenied = sessionsDenied;
        infoBase.ScheduledJobsDenied = sessionsDenied;
        infoBase.PermissionCode = unlockCode;
        cwp.UpdateInfoBase(infoBase);
        
    }

}

function KillUsers1C() {

    log("KillUsers1C: " + GetDate());
   
    var params = Connect1C();
    if (params) {

        var serverAgent = params.serverAgent;
        var cluster = params.cluster;
        var infoBase = params.infoBase;
        var cwp = params.cwp;

        ibDesc = cwp.CreateInfoBaseInfo();
        ibDesc.Name = infoBase.Name;

        var connections = cwp.GetInfoBaseConnections(ibDesc).toArray();
        for (var i in connections) {
            var connection = connections[i];
            log("kill: " + connection.ConnID);
            cwp.Disconnect(connection);
        }
 
        var sessions = serverAgent.GetSessions(cluster).toArray();
        for (var i in sessions) {
            var session = sessions[i];
            if (session.InfoBase.Name === infoBase.Name) {
                log("kill: " + session.SessionID + ", " + session.UserName);
                serverAgent.TerminateSession(cluster, session);
            }    
        }
    
    }    
}    

function BackupDB() {

    log("BackupDB: " + GetDate());

    var queryText =
    "BACKUP DATABASE " + db + 
    " TO DISK='" + backupFile + "'" +
    " WITH" +        
    " FORMAT, COPY_ONLY, STATS";

	var cmdText = "sqlcmd -E -S " + sqlServer + " -Q " + '"' + queryText + '"';
    log(cmdText);

    WshShell.Run(cmdText, 1, true);
}

function LoadCF() {
    log("LoadCF: " + GetDate());
    var cmdText = '"' + v8exe + '"' + " DESIGNER /S" + server + "\\" + db + " /UC" + unlockCode + " /LoadCfg" + cf;
    log(cmdText);
    WshShell.Run(cmdText, 1, true);
}

function UpdateDB() {
    log("UpdateDB: " + GetDate());
    var cmdText = '"' + v8exe + '"' + " DESIGNER /S" + server + "\\" + db + " /UC" + unlockCode + " /UpdateDBCfg -Server /Out" + logFile;
    log(cmdText);
    WshShell.Run(cmdText, 1, true);
}

function Start1C() {
    log("Start1C: " + GetDate());
    var cmdText = '"' + v8cexe + '"' + " ENTERPRISE /S" + server + "\\" + db + " /UC" + unlockCode + " /CВыполнитьОбновлениеИЗавершитьРаботу";
    log(cmdText);
    WshShell.Run(cmdText, 1, false);
}

function run() {

    log(db);

    if (!fso.FileExists(cf)) {
        log("File not found: " + cf);
        return;
    }

    if (db === "PLPK_K3_ERP") {
        BackupDB();
    }

    LoadCF();
    ChangeIBParams1C(true);
    KillUsers1C()

//    WScript.Sleep(1000);

    UpdateDB();
    Start1C();
    ChangeIBParams1C(false);

}
