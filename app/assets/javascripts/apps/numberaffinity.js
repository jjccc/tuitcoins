$(document).ready(function(){

  $("#tweet-button").on("click", function(){
    $.ajax({
          type: "post",
          url: Routes.user_tweet_path(gon.user_id, {app: "numberaffinity"}),
          dataType: "json"
    }).success(function(data, textStatus, jqXHR){
                     alert("Has enviado un tuit con tu resultado.");
    });
  });
  
});