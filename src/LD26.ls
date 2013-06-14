package
{
	import cocosdenshion.SimpleAudioEngine;
    import loom.Application;
    import loom.graphics.Graphics;
	import loom2d.display.Sprite;
	import loom2d.display.StageScaleMode;
	import loom2d.ui.TextureAtlasManager;

    public class LD26 extends Application
    {
        private var _gameView:GameView = null;
        private var _hud:HUDView;
        private var _gameOverView:GameOverView = null;
    
        override public function run():void
        {
            super.run();

            Graphics.setDebug(Graphics.DEBUG_TEXT);
            
            TextureAtlasManager.register("sprites", "assets/");

            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.GOOD_SFX);
            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.BAD_SFX);
            
            stage.stageWidth = 1024;
            stage.stageHeight = 768;
            stage.scaleMode = StageScaleMode.LETTERBOX;
            stage.color = 0x646464;
            
            _gameView = new GameView();
            
            _hud = new HUDView();
            
            _gameOverView = new GameOverView();
            _gameOverView.onReset += onGameStart;
            _gameOverView.onFadeIn += onGameOverFadeIn;
            
            onGameStart();
        }
        
        public function onGameStart()
        {
            _gameView.enter(stage);
            _gameView.level.owningGroup = group;
            _gameView.level.onGameOver += onGameOver;
            
            _gameView.level.onGameBegan += _hud.onGameBegan;
            _gameView.level.onTimeChanged += _hud.onTimeChanged;
            _gameView.level.onPolarityChanged += _hud.onPolarityChanged;
            _hud.enter(stage);
        }
        
        public function onGameOver(survivalTime:int, bestTime:int)
        {
            _gameOverView.enter(stage);
        }
        
        public function onGameOverFadeIn()
        {
            // We can kill our game once the game over screen is faded in
            _gameView.exit();
            _hud.exit();
        }
    }
}