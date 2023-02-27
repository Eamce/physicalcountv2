class ServerUrlList{
  //--------------------------> Note: Local IP should the same with the default IP <----------------------
  static var _serverUrlList = {'Local'   : 'http://172.16.163.2:81/pcount_app/pcount_local/',
                               /*'Alturas' : 'http://172.16.163.2:81/pcount_app/pcount_alturas/',*/
                               'Marcela' : 'http://172.16.163.2:81/pcount_app/pcount_pm/',
                               /*'ICM'     : 'http://172.16.163.2:81/pcount_app/pcount/',*/};

  serverUrlKey()=> _serverUrlList.entries.map((e) => e.key).toList();
  serverUrlValue()=> _serverUrlList.entries.map((e) => e.value).toList();
  ip(String serverName)=> _serverUrlList['$serverName'];
  server(String ip)=> _serverUrlList.keys.firstWhere((e) => _serverUrlList[e] == ip, orElse: () => "Not found");
}