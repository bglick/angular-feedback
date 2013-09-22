describe 'feedbackWidget', () ->
  elem = scope = $httpBackend = null

  beforeEach () ->
    module '$feedback.directives'
    inject ($injector) ->
      $rootScope = $injector.get('$rootScope')
      $httpBackend = $injector.get('$httpBackend')
      $compile = $injector.get('$compile')
      $httpBackend.when('POST', '/x').respond({ok: 'ok'})
      scope = $rootScope.$new()
      html = '<feedback-widget url="/x" thanksText="y" />'
      elem = angular.element html
      compiled = $compile(elem)(scope)
      scope.$digest()

  it "should set html", () ->
    expect(elem.html()).toMatch(/btn-feedback-submit/)

  it "should change viewMode on click", () ->
    expect(elem.scope().viewMode).toEqual('sm')
    $(elem).find('button.btn-feedback-toggle').click()
    expect(elem.scope().viewMode).toEqual('lg')

  it "should post on click", () ->
    $httpBackend.expectPOST('/x','{"feedback":{"comment":"mycomment"}}')
    elem.scope().url = '/x'
    elem.scope().feedback.comment = 'mycomment'
    $(elem).find('button.btn-feedback-submit').click()

  it "should show thank you message after click", () ->
    elem.scope().url = '/x'
    $(elem).find('button.btn-feedback-submit').click()
    expect(elem.scope().thanksMsg).toBe(true)
