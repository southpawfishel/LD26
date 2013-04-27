package
{
    import cocos2d.Cocos2DGame;
    import cocos2d.CCSprite;
    import cocos2d.ScaleMode;

    import UI.Label;

    public class LD26 extends Cocos2DGame
    {
        private var _gameView:GameView = null;
    
        override public function run():void
        {
            super.run();
            
            layer.scaleMode = ScaleMode.LETTERBOX;
            layer.designWidth = 960;
            layer.designHeight = 640;
            
            _gameView = new GameView();
            _gameView.group = group;
            _gameView.enter(layer);
        }
    }
}