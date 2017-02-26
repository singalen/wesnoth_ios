/*	SDLMain.m - main entry point for our Cocoa-ized SDL app
	Initial Version: Darrell Walisser <dwaliss1@purdue.edu>
	Non-NIB-Code & other changes: Max Horn <max@quendi.de>
	Edited a lot for Wesnoth by Ben Anderman <ben@happyspork.com>
*/

#import "SDL.h"
#import "SDLMain.h"
#include <vector>

extern "C" int wesnoth_main(int argc, char **argv);
static std::vector<char*> gArgs;


int HandleAppEvents(void *userdata, SDL_Event *event)
{
	switch (event->type)
	{
		case SDL_APP_TERMINATING:
			/* Terminate the app.
               Shut everything down before returning from this function.
            */
			return 0;
		case SDL_APP_LOWMEMORY:
			/* You will get this when your app is paused and iOS wants more memory.
               Release as much memory as possible.
            */
			return 0;
		case SDL_APP_WILLENTERBACKGROUND:
			/* Prepare your app to go into the background.  Stop loops, etc.
               This gets called when the user hits the home button, or gets a call.
            */
			return 0;
		case SDL_APP_DIDENTERBACKGROUND:
			/* This will get called if the user accepted whatever sent your app to the background.
               If the user got a phone call and canceled it, you'll instead get an SDL_APP_DIDENTERFOREGROUND event and restart your loops.
               When you get this, you have 5 seconds to save all your state or the app will be terminated.
               Your app is NOT active at this point.
            */
			return 0;
		case SDL_APP_WILLENTERFOREGROUND:
			/* This call happens when your app is coming back to the foreground.
               Restore all your state here.
            */
			return 0;
		case SDL_APP_DIDENTERFOREGROUND:
			/* Restart your loops here.
               Your app is interactive and getting CPU again.
            */
			return 0;
		default:
			/* No special processing, add it to the event queue */
			return 1;
	}
}

//#ifdef main
//#  undef main
//#endif

/* Main entry point to executable - should *not* be SDL_main! */
int main (int argc, char **argv)
{
//    sdl2-ios guide: http://hg.libsdl.org/SDL/raw-file/9c6570c422c4/docs/README-ios.md

    SDL_SetEventFilter(HandleAppEvents, NULL);

	// Just a copy from OS X main(). Does iOS really use these?
    setenv ("SDL_ENABLEAPPEVENTS", "1", 1);
    setenv ("SDL_VIDEO_ALLOW_SCREENSAVER", "1", 1);

    /* Set config files for pango and fontconfig, so the data they need can be found */
    setenv ("PANGO_RC_FILE", "./pangorc", 1);
    setenv ("PANGO_SYSCONFDIR", ".", 1);
    setenv ("PANGO_LIBDIR", ".", 1);
    setenv ("FONTCONFIG_PATH", ".", 1);
    setenv ("FONTCONFIG_FILE", "fonts.conf", 1);

	gArgs.push_back(argv[0]); // Program name
	for (int i = 1; i < argc; i++) {
		// Filter out debug arguments that XCode might pass
		if (strcmp(argv[i], "-ApplePersistenceIgnoreState") == 0) {
			i++; // Skip the argument
			continue;
		}
		if (strcmp(argv[i], "-NSDocumentRevisionsDebugMode") == 0) {
			i++; // Skip the argument
			continue;
		}
		// This is passed if launched by double-clicking
		if (strncmp(argv[i], "-psn", 4) == 0) {
			continue;
		}
		gArgs.push_back(argv[i]);
	}
	gArgs.push_back(nullptr);


	/* Set the working directory to the .app's Resources directory */
    // FIXME: What here?
//    chdir([[[NSBundle mainBundle] resourcePath] fileSystemRepresentation]);

    /* Hand off to main application code */
    int status = wesnoth_main((int) gArgs.size() - 1, gArgs.data());

    /* We're done, thank you for playing */
    exit(status);
}
