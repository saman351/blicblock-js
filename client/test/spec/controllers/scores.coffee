'use strict'

describe 'Controller: ScoresCtrl', ->
  beforeEach module 'blicblockApp'

  Score = {}
  ScoresCtrl = {}
  scope = {}
  httpBackend = {}

  beforeEach inject ($injector, $controller, $rootScope) ->
    scope = $rootScope.$new()
    Score = $injector.get('Score')
    httpBackend = $injector.get('$httpBackend')
    ScoresCtrl = $controller 'ScoresCtrl',
      $scope: scope
      Score: Score
    httpBackend.expectGET('/api/scores.json?initials=&order=value&time=week')
               .respond
                 scores: [value: 1000, initials: 'ABC']
                 page: 1
                 total_pages: 1
                 total_records: 1
    httpBackend.flush()

  it 'sets up score filters', ->
    expect(scope.filters).toBeDefined()

  it 'queries list of scores', ->
    expect(scope.score_results).toBeDefined()
    expect(scope.score_results.page).toEqual 1
    expect(scope.score_results.total_pages).toEqual 1
    expect(scope.score_results.total_records).toEqual 1
    expect(scope.score_results.scores[0].value).toEqual 1000
    expect(scope.score_results.scores[0].initials).toEqual 'ABC'

  describe 'filter', ->
    it 'makes query with filters', ->
      scope.filters.time = 'a'
      scope.filters.initials = 'b'
      scope.filters.order = 'c'
      httpBackend.expectGET('/api/scores.json?initials=b&order=c&time=a')
                 .respond
                   scores: [value: 250, initials: 'COO']
                   page: 1
                   total_pages: 1
                   total_records: 1
      scope.filter()
      httpBackend.flush()
      expect(scope.score_results).toBeDefined()
      expect(scope.score_results.page).toEqual 1
      expect(scope.score_results.total_pages).toEqual 1
      expect(scope.score_results.total_records).toEqual 1
      expect(scope.score_results.scores[0].value).toEqual 250
      expect(scope.score_results.scores[0].initials).toEqual 'COO'
