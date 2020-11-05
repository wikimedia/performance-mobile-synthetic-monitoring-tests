module.exports = async function ( context, commands ) {
	commands.meta.setTitle( 'Test 20 random pages' );
	commands.meta.setDescription(
		'Go to the main page, click random and measure the page load.'
	);
	for ( let page = 0; page < 20; page++ ) {
		await commands.navigate( 'https://en.m.wikipedia.org/wiki/Main_Page' );
		await commands.measure.start();
		await commands.click.bySelector( '#mw-mf-main-menu-button' );
		await commands.wait.byTime( 2000 );
		await commands.click.bySelector(
			'#p-navigation > li:nth-child(2) > a > span'
		);
		await commands.wait.byPageToComplete();
		await commands.measure.stop();
	}
};
