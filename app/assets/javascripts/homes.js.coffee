@mangaSearch = angular.module 'mangaSearch', ['ngRoute', 'searchController']

@mangaSearch.config [
  '$routeProvider',
  ($routeProvider) ->
    $routeProvider.
      when('/search', 
        templateUrl: '/partials/search-form.html',
        controller: 'searchController'
      ).
      when('/manga/title/:title',
        templateUrl: '/partials/manga-detail.html'
        controller: 'titleController'
      ).
      when('/manga/chapter',
        templateUrl: '/partials/manga-chapter.html'
        controller: 'chapterController'
      ).
      otherwise(redirectTo: '/search')
]

@searchController = angular.module 'searchController', []

@searchController.controller('searchController', ['$scope', '$http', ($scope, $http) ->
  $scope.$watch('query', (newVal, oldVal)->
    if newVal.length > 3
      $http.post('/manga/search', {query: newVal}, headers: {'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}).
        success((data, status)->
          $scope.mangas = data
        )
  ,true
  )
])

@searchController.controller('titleController', ['$scope', '$routeParams', '$http', ($scope, $routeParams, $http) ->
  $scope.title = $routeParams.title
  $http.post('/manga/detail', {title: $scope.title}, headers: {'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}).
    success (data, status)->
      $scope.chapters = data
])

@searchController.controller('chapterController', ['$scope', '$routeParams', '$http', ($scope, $routeParams, $http) ->
  $scope.is_loading = true
  $scope.is_error = false
  $scope.chapter = $routeParams.chapter
  $http.post('/manga/chapter', {chapter: $scope.chapter}, headers: {'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')}).
    success (data, status)->
      $scope.is_loading = false
      $scope.chapters = data
    .error (data, status) ->
      $scope.is_loading = false
      $scope.is_error = true
])
