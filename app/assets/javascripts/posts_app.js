var app = angular.module('posts', 
          [
            'ngRoute',
            'ngResource',
            'ngMessages',
            'templates'      
          ]);
app.config([
            "$routeProvider",
   function($routeProvider) {
       $routeProvider.when("/", {
         controller: "SearchPostController",
         templateUrl: "seeking_post_search.html"
         }).when("/:id",{
         controller: "SeekingDetailController",
         templateUrl: "seeking_detail.html"
         });
    }
]);

app.controller("SearchPostController", [
       '$scope', '$http', '$location',
  function($scope , $http , $location){
   var page = 0;
   $scope.posts = [];
    $scope.search  =  function(searchTerm) {
    // $scope.searchedFor = searchTerm;
       if (searchTerm.length < 3) {
    return;
   }
   $http.get("/customers_seeking_posts.json", { "params": { "keywords": searchTerm, "page": page } } ).then(function(response) { $scope.posts = response.data; },
  function(response) { alert("There was a problem: " + response.status); }  );

    }
   $scope.previousPage = function() {
    if (page > 0) {
     page = page - 1;
     $scope.search($scope.keywords);
    }
  }
  $scope.nextPage = function() {
    page = page + 1;
    $scope.search($scope.keywords);
  }

 $scope.viewPostDetails = function(post) {
    $location.path("/" + post.post_id);
 }


  }
]);

app.controller("SeekingDetailController", [
        "$scope","$routeParams","$resource", "$window",
   function($scope , $routeParams , $resource , $window) {
     $scope.post_id   = $routeParams.id;
        var CustomersSeekingPost = $resource('/customers_seeking_posts/:post_id.json',
                                      {"post_id" : "@post_id"},
                                       {"save" : {"method" : "PUT"}});
       $scope.seeking_post = CustomersSeekingPost.get({"post_id": $scope.post_id});

$scope.goBack = function() {
 $window.history.back(); };
   }
]);

app.controller("NewSeekingPostController", [ "$scope","$resource",
 function($scope , $resource) {

var Categories = $resource('/categories.json/:id')
$scope.categories = Categories.query();
$scope.category = $scope.categories[0];

var Cities = $resource('/cities.json')
 $scope.cities = Cities.query();
 $scope.city = $scope.cities[0];
 
 $scope.addNewPost = function(){
   var Posts = $resource('/posts')

   $scope.newPost = Posts.save({category_id:$scope.category,city_id:$scope.city,title:$scope.title,content:$scope.content}, function(response){ $scope.message = response.message; }) ;
     $scope.category='';
     $scope.city='';
     $scope.title='';
     $scope.content='';   
  }

 $scope.image = "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNvffIiftgHzL0JjRSwxeFbyeOPO_tkn8R1qQBlyxIbHTbaPV8";

 }
]);


