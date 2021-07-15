<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String id = (String)session.getAttribute("user_id"); %>  
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
		<link rel="stylesheet" href="/resources/css/newCss.css" type="text/css">
		<link rel="stylesheet" href="/resources/css/NewCSS2.css" type="text/css">
		
		<script type="text/javascript">
		
			/* 페이지가 로드 되자마자 해야할 일 */
			$(function ready(){
				var bidT = getParameterByName('bid');

				readyBoard()
				readyCmt(bidT)
			})
			
			
			/* URL 파라미터 값을 읽어오는 정규식 */
			function getParameterByName(name) {
			  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
			  var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
			  results = regex.exec(location.search);
			  return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
			}
			
			/* 상세페이지 읽어오기  */
			function readyBoard(){

				var bidT = getParameterByName('bid');
				
				$.ajax({
					url:"doView",
					type:"POST",
					data:{
						bid:bidT
					},
					dataType:"JSON",
					success:function(data){
						
						document.getElementById("writerTemp").innerHTML = data.boardDto.user_id;
						document.getElementById("hitTemp").innerHTML = data.boardDto.hit;
						document.getElementById("titleTemp").innerHTML = data.boardDto.title;
						document.getElementById("contentTemp").innerHTML = data.boardDto.bcontents;
						document.getElementById("fileTemp").innerHTML = data.boardDto.fileName;
						
						var login_id = data.login_id;
						var user_id = data.boardDto.user_id;
						
						if(login_id  == user_id){
							htmlbtn = "";
							
							htmlbtn +="<form method='post' enctype='multipart/form-data' id='editForm' name='editForm'>";
							htmlbtn +="<input type='hidden' id='user_id' name='user_id' value='"+data.boardDto.user_id+"'>";
							htmlbtn +="<input type='hidden' id='bid' name='bid' value='"+data.boardDto.bid+"'>";
							htmlbtn +="<input type='hidden' id='title' name='title' value='"+data.boardDto.title+"'>";
							htmlbtn +="<input type='hidden' id='bcontents' name='bcontents' value='"+data.boardDto.bcontents+"'>";
							htmlbtn +="<input type='hidden' id='fileName' name='fileName' value='"+data.boardDto.fileName+"'>";
							htmlbtn +="<input type='hidden' id='rmt' name='rmt' value='edit'>";
							htmlbtn +="<input type='hidden' id='file' name='file'>";
							
							htmlbtn += "<input type='hidden' id='updateSubmit' onclick='editCheck()' value='수정완료'>";
							htmlbtn += "<input type='button' id='updateBtn' value='수정' onclick='editToggle(this.form)'>";
							htmlbtn += "<input type='button' value='삭제' onclick='del()'>";
							htmlbtn += "</form>"
							
							$('#formspace').html(htmlbtn);
						} 
							
					},
					error:function(){
						alert('페이지를 불러오는데 실패하였습니다.')
					}
				}) 
				
			}
			
			function editToggle(f){
				  if ($('#updateBtn').val() == '수정'){
					  updateOpen(f);
					  $('#updateBtn').val('취소')
				  }else {
					  updateClose(f)
					  $('#updateBtn').val('수정')
				  }
			}
			
			function updateOpen(){
				  $('#titleTemp').attr('contenteditable',true);
				  $('#titleTemp').css('background','orange');
				  $('#contentTemp').attr('contenteditable',true);
				  $('#contentTemp').css('background','orange');	
					
				  $('#updateSubmit').attr('type','button');
				  $('#file').attr('type','file');
			}

			function updateClose(){
				  $('#titleTemp').attr('contenteditable',false);
				  $('#titleTemp').css('background','none');
				  $('#contentTemp').attr('contenteditable',false);
				  $('#contentTemp').css('background','none');
					
				  document.getElementById("titleTemp").innerHTML =$("#title").val();
				  document.getElementById("contentTemp").innerHTML =$('#bcontents').val();
				  
				  $('#file').attr('type','hidden');
				  
				  $('#updateSubmit').attr('type','hidden');
			}
			
			function cmtEditToggle(f){
				if ( $(f.commentToggle).val() == '수정' ){
				
				$(f).css("border","3px solid red");
				$(f.contentTemp).attr("readonly",false)
				$(f.contentTemp).focus();
				$(f.commentHidden).attr("type","button")			
				$(f.commentToggle).val('취소')
				
			}else {
				$(f.contentTemp).val( $(f.recontent).val() )
				
				$(f).css("border","1px solid #e8e8e8");
				$(f.contentTemp).attr("readonly",true)
				$(f.commentHidden).attr("type","hidden")
				$(f.commentToggle).val('수정')
			}
				
		}
			
			/* 수정 적용된 값 db로 보내기 & 수정된 값 유지*/
			function editCheck(){
				
				var titleTemp = document.getElementById('titleTemp').innerText
				var contentTemp = document.getElementById('contentTemp').innerText
				var pageT = getParameterByName('page');
				
				 if (titleTemp == ''){
					  alert('제목을 입력해주세요.')
					  $('#titleTemp').focus();
					  return;
				  }
				  if (contentTemp == ''){
					  alert('내용을 입력해주세요.')
					  $('#contentTemp').focus();
					  return;
				  }
				  
				  $('#title').val ( titleTemp );
				  $('#bcontents').val ( contentTemp );
				  
				// 수정 Form을 담아줌			  
				 var form =$('#editForm')[0];  
				
				// FormData object 생성
				  var data = new FormData(form);
				  				  
				  $.ajax({
					  url:"doEdit",
					  type:"POST",
					  enctype:"multipart/form-data",
					  data: data,
					  processData: false,
					  contentType: false,
					  cache: false,
					  timeout: 600000,
					  dataType:"JSON",
					  success:function(data){
							if(data.result == "true"){
								alert('게시물 수정이 완료되었습니다.')
								editToggle()
								updateClose()
								window.opener.paging(pageT);
							}
					  },
					  error:function(){
						  alert('게시물 수정에 실패하였습니다.')
					  }
				  })
			}
			
			/* 게시글 삭제 */
			function del(bidT){
				
				var bidT = getParameterByName('bid')
				var pageT = getParameterByName('page');
				
				if(confirm('삭제하시겠습니까?')){
					$.ajax({
						url:"del",
						type:"POST",
						data:{bid:bidT},
						dataType:"JSON",
						success:function(data){
							if(data.result == "true"){
								alert('게시물 삭제가 완료되었습니다.')
								window.opener.paging(pageT)
								self.close()
							}
						},
						error:function(){
							alert('게시물 삭제에 실패하였습니다.')
						}
					})
				}else{
					return false;
				}
				
			}
			
			
			/* 댓글 리스트 읽어오기 */
			  function readyCmt(bidT){
				
			 	$.ajax({
					url:"doCmt",
					type:"POST",
					data:{
						bid:bidT
					},							
					dataType:"JSON",
					success:function(data){
						
						htmlcmt ="";
						if(data.clist.length == 0){
							htmlcmt +="<div># 현재 작성된 댓글이 없습니다.</div>";			
						}else{
							for(i=0; i<data.clist.length; i++){
								htmlcmt += "<form class='commentBox' method='post' id='cmtEditForm'>";
								htmlcmt += "<input type='hidden' name='bid' value='"+data.clist[i].bid+"'>";
								htmlcmt += "<input type='hidden' name='cid' value='"+data.clist[i].cid+"'>";
								htmlcmt += "<input type='hidden' name='recontent' value='"+data.clist[i].recontent+"'>";
								htmlcmt += "<input type='hidden' name='crmt' value='edit'>";
								htmlcmt += "<strong>"+data.clist[i].user_id+"</strong>";
								htmlcmt += "<span class='date'>"+data.clist[i].cdate+"</span>";
								htmlcmt += "<p class='reply_cont'>"+data.clist[i].recontent+"</p>";
								
								var login_id = data.login_id;
								var user_id = data.clist[i].user_id;
								
								if(login_id  == user_id){
									htmlcmt += "<input type='hidden' id='commentHidden' onclick='cmtAdd(this.form,"+data.clist[i].bid+")' value='수정완료'>";
									htmlcmt += "<input type='button' id='commentToggle' value='수정' onclick='cmtEditToggle(this.form)'>";
									htmlcmt += "<input type='button' value='삭제' onclick='cmtDel("+data.clist[i].bid+","+data.clist[i].cid+")'>	";
								}
								
								htmlcmt += "</form>";
							}
						}
							$('#replybox').html(htmlcmt);
					},
					error:function(){
						alert('페이지를 불러오는데 실패하였습니다.')
					}
				}) 
				
			} 
			
			/* 댓글 삭제 */
			function cmtDel(bidT,cidT){
			if(confirm('댓글을 삭제하시겠습니가?')){
				
				$.ajax({
					url:"delCmt",
					type:"POST",
					data: {
						bid:bidT,
						cid:cidT
					},
					dataType:"JSON",
					success:function(data){
						if(data.result == "true"){
							readyCmt(bidT)
						}
					},
					error:function(){
						alert('댓글 삭제에 실패하였습니다.')
					}
				})
			}else{
				return false;
			}
			
		}
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		</script>
	</head>
	<body>
	<div id="wrap">
		<div class="sub_padding">
		<div class="sub_container">
		<div id="contents">
			<!-- content Start -->
				<div id="content">
					<div class="sub_top" id="sub_top01"> 
					<h2>상세보기</h2>
				</div>
				<div id="bbs_wrap">
								<div class="board_view">
									<dl class="tit_view2">
										<dt>제목</dt>
										<dd id="titleTemp"></dd>
									</dl>
									<dl class="info_view2">
										<dt class="writer">작성자</dt>
										<dd class="writer" id="writerTemp"></dd>
										<dt>작성일</dt>
										<dd> <%-- ${map.boardDto.day } --%></dd>
										<dt>조회수</dt>
										<dd id="hitTemp"></dd>
									</dl>
									<dl class="file_view">
										<dt>첨부파일</dt>
										<dd id="fileTemp"></dd>
									</dl>
									<div class="view_cont" id="contentTemp">
									</div>
										<%-- 게시물 수정/삭제 버튼 --%>	
											<div class="bbs_reply">
												<div class="fR" id="formspace">

												</div>
											</div>		

										<%-- 답글 버튼--%>
											<div class="bg_btn">	
												<input type="button" onclick="add_view('${map.boardDto.bid}')" value="답글달기">
											</div>
									
									
									
									
									<%-- 댓글 출력 부분 --%>	
										<div class="bbs_reply">
											<h4>개의 댓글이 있습니다.</h4>
											<div class="reply type1" id="replybox">
													<div># 현재 작성된 댓글이 없습니다.</div>
													<form class="commentBox" method="post" id="cmtEditForm">
														<input type="hidden" name="bid" value="">
														<input type="hidden" name="cid" value="${cdto.cid }">
														<input type="hidden" name="recontent" value="${cdto.recontent }">
														<input type="hidden" name="crmt" value="edit">
													
													<strong>${cdto.user_id }</strong> 
													<span class="date">${cdto.cdate }
													
													<%-- 로그인된 아이디와 작성자가 같을 경우 --%>
																<input type="hidden" id="commentHidden" onclick="cmtAdd(this.form,'${map.boardDto.bid}')" value="수정완료">
																<input type="button" id="commentToggle" value="수정" onclick="cmtEditToggle(this.form)">			        
																<input type="button" value="삭제" onclick="cmtDel('${map.boardDto.bid }','${cdto.cid}')">			        
													</span>	
													<p class="reply_cont">${cdto.recontent }</p>	
													</form>
											</div>
											
									<%-- // --%>
									<%-- 댓글 작성 부분 --%>
									<div class="comment">
										<div class="comment_inp">
											<form method="post" id="cmtAddForm">
	
												<input type="hidden" name="user_id" id="user_id" value="<%=id%>">
			 									<input type="hidden" name="bid" id="bid" value="${map.boardDto.bid }">
			 									<input type="hidden" name="crmt" value="add">	
												
												<strong>댓글쓰기</strong>
												<textarea rows="0" cols="0" maxlength="2000"  id="recontent" name="recontent" placeholder="댓글을 입력하세요."></textarea>
												<span class="bbtn_input">
													<input type="button" onclick="cmtAdd(this.form,'${map.boardDto.bid}')" value="등록"></span>
												<p>최대 2,000자까지 입력가능합니다.</p>
											</form>
										</div>
									</div>
									<%-- // --%>
								</div><!-- bbs wrap -->
							</div>
						</div>
	
					</div>
				</div>
				</div></div></div>
	</body>
</html>