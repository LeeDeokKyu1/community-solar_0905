const MiilkAuth={loginProvider:null,loginUserId:null,password:null,socialToken:null,socialInfo:null,signupInfo:function(){var o=localStorage.getItem("loginProvider"),e=localStorage.getItem("socialToken"),i=localStorage.getItem("socialInfo");null!==o&&0!==o.length&&null!==e&&0!==e.length&&(this.loginProvider=o,this.socialToken=JSON.parse(e),0!==i.length&&(this.socialInfo=JSON.parse(i))),localStorage.removeItem("loginProvider"),localStorage.removeItem("socialToken"),localStorage.removeItem("socialInfo")},login:function(o){const e={login_provider:this.loginProvider,login_user_id:this.loginUserId,password:this.password,social_token:this.socialToken};var i=this.socialInfo;$.ajax({type:"POST",url:"/login",dataType:"json",data:e,success:function(){o(!0,null)},error:function(l){10004===l.responseJSON.errorCode?(localStorage.setItem("loginProvider",e.login_provider),localStorage.setItem("socialToken",JSON.stringify(e.social_token)),localStorage.setItem("socialInfo",JSON.stringify(i)),location.href=`/signup?login_provider=${e.login_provider}`):null!=l.responseJSON.message?o(!1,l.responseJSON.message):o(!1,"\ub2e4\uc2dc\uc2dc\ub3c4\ud574\uc8fc\uc138\uc694.")}})},setIdPassword:function(o,e){this.loginProvider="email",this.loginUserId=o,this.password=e},setSocialToken:function(o,e,i){this.loginProvider=o,this.socialToken=e,this.socialInfo=i,this.loginUserId=i.id}};