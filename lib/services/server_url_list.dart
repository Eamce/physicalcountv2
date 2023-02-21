class ServerUrlList{

  static var _serverUrlList = {'Local'   : 'http://172.16.163.2:81/pcount_app/pcount_local/',
                               'Alturas' : 'http://172.16.163.2:81/pcount_app/pcount_alturas/',
                               'Marcela' : 'http://172.16.163.2:81/pcount_app/pcount_pm/',
                               'ICM'     : 'http://172.16.163.2:81/pcount_app/pcount/',};

  serverUrlKey()=> _serverUrlList.entries.map((e) => e.key).toList();
  serverUrlValue()=> _serverUrlList.entries.map((e) => e.value).toList();
  ip(String serverName)=> _serverUrlList['$serverName'];
}