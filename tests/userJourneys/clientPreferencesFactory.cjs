const URL_BASE = 'https://en.wikipedia.org';

module.exports = function ( title, description, path, onMainPage ) {
	return async function ( context, commands ) {
		commands.meta.setTitle( title );
		commands.meta.setDescription( description );

		// Visit Main_Page and execute onMainPage callback.
		await commands.navigate( `${URL_BASE}?useformat=desktop` );
		await onMainPage(commands);

		return commands.measure.start( `${URL_BASE}${path}`);
	}
}
