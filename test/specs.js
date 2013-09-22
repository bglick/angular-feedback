(function() {
  describe('feedbackWidget', function() {
    var $httpBackend, elem, scope;
    elem = scope = $httpBackend = null;
    beforeEach(function() {
      module('$feedback.directives');
      return inject(function($injector) {
        var $compile, $rootScope, compiled, html;
        $rootScope = $injector.get('$rootScope');
        $httpBackend = $injector.get('$httpBackend');
        $compile = $injector.get('$compile');
        $httpBackend.when('POST', '/x').respond({
          ok: 'ok'
        });
        scope = $rootScope.$new();
        html = '<feedback-widget url="/x" thanksText="y" />';
        elem = angular.element(html);
        compiled = $compile(elem)(scope);
        return scope.$digest();
      });
    });
    it("should set html", function() {
      return expect(elem.html()).toMatch(/btn-feedback-submit/);
    });
    it("should change viewMode on click", function() {
      expect(elem.scope().viewMode).toEqual('sm');
      $(elem).find('button.btn-feedback-toggle').click();
      return expect(elem.scope().viewMode).toEqual('lg');
    });
    it("should post on click", function() {
      $httpBackend.expectPOST('/x', '{"feedback":{"comment":"mycomment"}}');
      elem.scope().url = '/x';
      elem.scope().feedback.comment = 'mycomment';
      return $(elem).find('button.btn-feedback-submit').click();
    });
    return it("should show thank you message after click", function() {
      elem.scope().url = '/x';
      $(elem).find('button.btn-feedback-submit').click();
      return expect(elem.scope().thanksMsg).toBe(true);
    });
  });

}).call(this);
