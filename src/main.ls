// THIS IS THE ENTRY POINT TO YOUR APPLICATION
// YOU DON'T WANT TO MESS WITH ANYTHING HERE
// UNLESS YOU KNOW WHAT YOU'RE DOING
package
{
    import cocos2d.Cocos2DApplication;

    static class Main extends Cocos2DApplication
    {
        protected static var game:LD26 = new LD26();

        public static function main()
        {
            initialize();
            onStart += game.run;
        }
    }
}