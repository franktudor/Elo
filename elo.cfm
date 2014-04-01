<cfscript>
function determineRatingConstant(required numeric rating) {
	
	// Some rating contants depending strong or weak ratings.
	// Note I want the middle range wins to count higher
	// because players in that spectum would face higher competition
	// You might see this differntly or this could be 
	var returnVal = 10;
		if (rating GT 2400) { 		
			returnVal = 5; 	
		} else if (rating GT 2300 AND rating LTE 2400) {
			returnVal = 10;
		} else if (rating GT 2200 AND rating LTE 2300) {
			returnVal = 20;
		} else if (rating GT 2100 AND rating LTE 2200) {
			returnVal = 20;	
		} else if (rating GT 2000 AND rating LTE 2100) {
			returnVal = 10;										
		} else {
			returnVal = 5;
		}
	return returnVal;
}

function calculateNewRating(required numeric player1Rating, required numeric player2Rating, required numeric player1Victory){
	var outcome = 0;
		if (player1Victory) {
			outcome = 1;
		}
		
	// in coldfusion there is log10() but if I reverse things and plant a 
	// player2 victory it gives a divide by zero error so I am doing 10^
	// is this right?
	var expected_outcome = 1/(1+10^((player1Rating-player2Rating)/400));
	var k = determineRatingConstant(player1Rating);
	var newrating = round(player1Rating+k*(outcome-expected_outcome));

		// I am not sure I am doing this right but
		// there are sometimes decimals and negatives 
		// I need to deal with... this could be unnecessary
		// because I could be doing it wrong in expected 
		// outcome when I reverse things.
		if (outcome eq 0){
		newrating = round(abs(newrating));	
		}	
			
	return newrating;
}

// Here we call our functional stuff...
// Ok I am creating a struct here and I am setting some starting variables
// as you can see I have player two at an advantage.
// I give player A the first win too.
player = structNew();
player.rating1 = 2200;
player.rating2 = 2200;

// Lets run through 25 games and see the fate of your two players.
// Also if marktWin eq 1 that is a win for Player1
for (i=0;i<25;++i) {
	/*if ( i eq 0 ) {
		marktWin = 1;
	} else {
		marktWin = randrange(0,1); //you can comment this out to see player one have an unfair advantage
	}*/
	marktWin = randrange(0,1);
	player.rating1 = calculateNewRating(player.rating1, player.rating2, (marktWin ? 1 : 0));
	player.rating2 = calculateNewRating(player.rating2, player.rating1, (marktWin ? 0 : 1));
	writeOutput("game " & numberformat(i,'000')); //doing this to get a clean output 
	writeOutput(" : " & player.rating1 & " | " & player.rating2); // NOTE: inital player. struct values are overwritten
	writeOutput(" - Player 1:"); // below ternary operator funzies in Coldfusion
	writeOutput((marktWin ? " <span style='color:blue'><b>won</b></span>" : " <span style='color:red'>lost</span>")); 
	writeOutput("<br>"); 
}
</cfscript>