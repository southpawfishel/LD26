package
{
    import CocosDenshion.SimpleAudioEngine;
    import cocos2d.Cocos2D;
    import cocos2d.Cocos2DGame;
    import cocos2d.CCSprite;
    import cocos2d.ScaleMode;
    import cocos2d.CCSpriteBatchNode;
    import cocos2d.CCSpriteFrameCache;

    import UI.Atlas;
    import UI.Label;

    public class LD26 extends Cocos2DGame
    {
        private var _batchNode:CCSpriteBatchNode = null;

        private var _gameView:GameView = null;
        private var _hud:HUDView;
        private var _gameOverView:GameOverView = null;
    
        override public function run():void
        {
            super.run();
            
            Atlas.register("sprites", "assets/");
            CCSpriteFrameCache.sharedSpriteFrameCache().addSpriteFramesWithFile("assets/sprites.plist", "assets/sprites.png");

            _batchNode = CCSpriteBatchNode.create("assets/sprites.png");
            _batchNode.smoothed = false;
            layer.addChild(_batchNode, 1);
            group.registerManager(_batchNode);

            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.GOOD_SFX);
            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.BAD_SFX);
            
            layer.scaleMode = ScaleMode.LETTERBOX;
            layer.designHeight = 640;
            layer.designWidth = layer.designHeight * getAspectRatio();
            
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
            _gameView.enter(layer);
            _gameView.level.owningGroup = group;
            _gameView.level.onGameOver += onGameOver;
            
            _gameView.level.onGameBegan += _hud.onGameBegan;
            _gameView.level.onTimeChanged += _hud.onTimeChanged;
            _gameView.level.onPolarityChanged += _hud.onPolarityChanged;
            _hud.enter(layer);
        }
        
        public function onGameOver(survivalTime:int, bestTime:int)
        {
            _gameOverView.enter(layer);
        }
        
        public function onGameOverFadeIn()
        {
            // We can kill our game once the game over screen is faded in
            _gameView.exit();
            _hud.exit();
        }
    }
}