package
{
    import CocosDenshion.SimpleAudioEngine;
    import cocos2d.Cocos2D;
    import cocos2d.Cocos2DGame;
    import cocos2d.CCSprite;
    import cocos2d.ScaleMode;

    import UI.Atlas;
    import UI.Label;

    public class LD26 extends Cocos2DGame
    {
        private var _gameView:GameView = null;
    
        override public function run():void
        {
            super.run();
            
            Atlas.register("sprites", "assets/");
            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.GOOD_SFX);
            SimpleAudioEngine.sharedEngine().preloadEffect(PlayerOrbComponent.BAD_SFX);
            
            layer.scaleMode = ScaleMode.LETTERBOX;
            layer.designHeight = 640;
            layer.designWidth = layer.designHeight * getAspectRatio();
            
            _gameView = new GameView();
            _gameView.group = group;
            _gameView.enter(layer);
        }
        
        protected function getAspectRatio():Number
        {
            return (Cocos2D.getDisplayWidth() as Number) / (Cocos2D.getDisplayHeight() as Number);
        }
    }
}