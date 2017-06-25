/**
 * 
 */
function createNewProduction() {
	console.log("createNewProduction()");
	
	//$('#btn-confirm').click(function(){
		ajax_load();
		console.log("SSS");
		$.post('../ProductionServlet',$("#create_production_form").serialize(),function(resData){
					ajax_remove();
					if (resData.status == 'success') {
						window.location='plan_list_report.jsp';
					} else {
						alert(resData.message);
					}
				},'json');	
	//});
}