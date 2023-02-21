class ServerUrlList{

  static var _serverUrlList = {'Local'   : 'http://172.16.163.2:81/pcount_app/',
                               'Alturas' : 'http://172.16.163.2:81/pcount_app/',
                               'Marcela' : 'http://172.16.163.2:81/pcount_app/',
                               'ICM'     : 'http://172.16.163.2:81/pcount_app/',};

  serverUrlKey()=> _serverUrlList.entries.map((e) => e.key).toList();
  serverUrlValue()=> _serverUrlList.entries.map((e) => e.value).toList();
  ip(String serverName)=> _serverUrlList['$serverName'];
}