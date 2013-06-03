package
{
	import cocos2d.Cocos2D;
	import CocosDenshion.SimpleAudioEngine;
	import Loom2D.Display.Loom2DGame;
	import Loom2D.Display.Sprite;
	import Loom2D.Display.StageScaleMode;
	import Loom2D.UI.TextureAtlasManager;

    public class LD26 extends Loom2DGame
    {
        private var _gameView:GameView = null;
        private var _hud:HUDView;
        private var _gameOverView:GameOverView = null;
    
        override public function run():void
        {
            super.run();
            
            TextureAtlasManager.register("sprites", "assets/");

            group.registerManager(stage);

            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.GOOD_SFX);
            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.BAD_SFX);
            
            stage.scaleMode = StageScaleMode.LETTERBOX;
            stage.stageWidth = 1024;
            stage.stageHeight = 768;
            
            _gameView = new GameView();
            
            _hud = new HUDView();
            
            _gameOverView = new GameOverView();
            _gameOverView.onReset += onGameStart;
            _gameOverView.onFadeIn += onGameOverFadeIn;
            
            onGameStart();
        }
        
        protected function getAspectRatio():Number
        {
            return (Cocos2D.getDisplayWidth() as Number) / (Cocos2D.getDisplayHeight() as Number);
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