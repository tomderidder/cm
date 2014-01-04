###
# 网址列表
###
angular.module('urls', [
  'ui.bootstrap'
])

BodyCtrl = (scope, log, http)->
  scope.locale =
    en: true
    zh_CN: true
    zh_TW: true
    ru: true
  scope.mode =
    TXT: true
    MEN: true
    PIC: true
    LIN: true
  scope.type = {}
  scope.typeValue = [
    {c: 'all',    n:'通用'}
    {c: 'new',    n:'新闻'}
    {c: 'chrome', n:'谷歌浏览器'}
    {c: 'pic',    n:'图片'}
    {c: 'ui',     n:'设计'}
    {c: 'mp3',    n:'音乐'}
    {c: 'movie',  n:'视频'}
    {c: 'book',   n:'阅读'}
    {c: 'fy',     n:'翻译'}
    {c: 'comic',  n:'卡通'}
    {c: 'shop',   n:'购物'}
    {c: 'sns',    n:'社交'}
    {c: 'utils',  n:'工具'}
  ]
  for t in scope.typeValue
    scope.type[t.c] = true
  scope.getTypeName = (type)->
    for t in scope.typeValue
      if t.c == type
        return t.n
    ''
  scope.total = 50
  scope.numPages = 1
  scope.show = []
  scope.$watch('numPages',(n, o) ->
    if typeof scope.urls != 'undefined'
      scope.show = scope.urls[(n-1)*20..n*20]
  )
  scope.$watch('locale',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  , true)
  scope.$watch('mode',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  , true)
  scope.$watch('type',(n, o) ->
    scope.load()
    #lsSetItem('bl', n)
  , true)
  isLocale = (u)->
    # 判断是否显示该语言
    u.l == 'all' or scope.locale[u.l]
  isMode = (u)->
    # 判断是否是该模式
    scope.mode[u.m]
  isType = (u)->
    # 判断是否是该类型 #
    scope.type[u.t]
  scope.all = []
  scope.load = ->
    # 加载菜单
    scope.urls = []
    for u in scope.all
      b = isLocale(u)
      b = if b then isMode(u) else b
      b = if b then isType(u) else b
      if b
        scope.urls.push(u)
    scope.total = scope.urls.length
    scope.numPages = 1
    scope.show = scope.urls[0..20]
  scope.init = ->
    #http({method: 'GET', url: '/url/query/?t=1'}).
    http({method: 'GET', url: 'a.json'}).
    success((data, status, headers, config)->
      scope.all = data
      scope.load()
    ).error((data, status, headers, config)->
      console.error data
      alert(data)
    )
  scope.init()
BodyCtrl.$inject = ['$scope', '$log', '$http']
