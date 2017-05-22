//run with cscript
//auth via NTLM
var v8cexe     = "C:/1CData/8.3.9.2170_x64/bin/1cv8c.exe";
var v8exe      = "C:/1CData/8.3.9.2170_x64/bin/1cv8.exe";
var server     = "gr-rphost-01";
var sqlServer  = "gr-sql";
var db         = "PLPK_K3_ERP"
var cf         = "C:/1CData/release/1Cv8_2017-05-18.cf";
var logFile    = "N:/gr/dok/Users/AppData/sitnikov.a/1CData/update.log";
var unlockCode = "123321";
var backupFile = "E:\\temp\\" + db + ".bak";

var WshShell = WScript.CreateObject('WScript.Shell');

function GetDate() {

    var date = new Date;
    return date;

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
        WScript.Echo("Cluster not found");
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

    WScript.Echo("ChangeIBParams1C: " + GetDate());

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

    WScript.Echo("KillUsers1C: " + GetDate());
   
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
            WScript.Echo("kill: " + connection.ConnID);
            cwp.Disconnect(connection);
        }
 
        var sessions = serverAgent.GetSessions(cluster).toArray();
        for (var i in sessions) {
            var session = sessions[i];
            if (session.InfoBase.Name === infoBase.Name) {
                WScript.Echo("kill: " + session.SessionID + ", " + session.UserName);
                serverAgent.TerminateSession(cluster, session);
            }    
        }
    
    }    
}    

function BackupDB() {

    WScript.Echo("BackupDB: " + GetDate());

    var queryText =
    "BACKUP DATABASE " + db + 
    " TO DISK='" + backupFile + "'" +
    " WITH" +        
    " FORMAT, COPY_ONLY, STATS";

	var cmdText = "sqlcmd -E -S " + sqlServer + " -Q " + '"' + queryText + '"';
    WScript.Echo(cmdText);

    WshShell.Run(cmdText, 1, true);
}

function LoadCF() {
    WScript.Echo("LoadCF: " + GetDate());
    var cmdText = '"' + v8exe + '"' + " DESIGNER /S" + server + "\\" + db + " /UC" + unlockCode + " /LoadCfg" + cf;
    WScript.Echo(cmdText);
    WshShell.Run(cmdText, 1, true);
}

function UpdateDB() {
    WScript.Echo("UpdateDB: " + GetDate());
    var cmdText = '"' + v8exe + '"' + " DESIGNER /S" + server + "\\" + db + " /UC" + unlockCode + " /UpdateDBCfg -Server /Out" + logFile;
    WScript.Echo(cmdText);
    WshShell.Run(cmdText, 1, true);
}

function Start1C() {
    WScript.Echo("Start1C: " + GetDate());
    var cmdText = '"' + v8cexe + '"' + " ENTERPRISE /S" + server + "\\" + db + " /UC" + unlockCode + " /CВыполнитьОбновлениеИЗавершитьРаботу";
    WScript.Echo(cmdText);
    WshShell.Run(cmdText, 1, false);
}

function run() {

    fs = new ActiveXObject("Scripting.FileSystemObject");
    if (!fs.FileExists(cf)) {
        WScript.Echo("File not found: " + cf);
        return;
    }

    BackupDB();
    LoadCF();
    ChangeIBParams1C(true);
    KillUsers1C()

    WScript.Sleep(1000);

    UpdateDB();
    Start1C();
    ChangeIBParams1C(false);

}

run();


