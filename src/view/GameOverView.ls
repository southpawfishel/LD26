package
{
    
	import loom.animation.Tween;
	import loom.platform.Timer;
	import loom2d.display.DisplayObjectContainer;
	import loom2d.display.Image;
	import loom2d.display.Quad;
	import loom2d.display.Stage;
    import loom2d.Loom2D;
	import loom2d.textures.Texture;
	import loom2d.ui.Label;
	import ui.View;
	import ui.ViewCallback;
    
    public class GameOverView extends View
    {
        public var onReset:ViewCallback = new ViewCallback();
        public var onFadeIn:ViewCallback = new ViewCallback();
        
        protected var _gameOver:Label;
        
        protected var _fadeToBlack:Quad = null;
		protected var _tempBG:Image = null;
        
        public function GameOverView()
        {
            super();
        }
        
        public function enter(parent:DisplayObjectContainer)
        {
            super.enter(parent);
            
            var restartGameTimer:Timer = new Timer(3000);
            restartGameTimer.onComplete = onStartFadeOut;
            restartGameTimer.start();
            
            _fadeToBlack = new Quad(Loom2D.stage.stageWidth, Loom2D.stage.stageHeight, 0x000000);
            _fadeToBlack.alpha = 0;
            addChild(_fadeToBlack);
            
            _gameOver = new Label();
            _gameOver.fontFile = "assets/Curse-hd.fnt";
            _gameOver.text = "GAME OVER";
            _gameOver.x = Loom2D.stage.stageWidth / 2;
            _gameOver.y = Loom2D.stage.stageHeight / 2;
            _gameOver.pivotX = _gameOver.width / 2;
            _gameOver.pivotY = _gameOver.height / 2;
            _gameOver.scale = 0.5;
            _gameOver.alpha = 0;
            addChild(_gameOver);
            
            Tween.to(_gameOver, 0.5, { "alpha" : 1 });
            Tween.to(_fadeToBlack, 0.5, { "alpha" : 1 }).onComplete = function(tween:Tween)
            {
                onFadeIn();
            }
            
            parent.setChildIndex(this, 100);
        }
        
        public function exit()
        {
            Tween.to(_gameOver, 0.5, { "alpha" : 0 });
            Tween.to(_fadeToBlack, 0.5, { "alpha" : 0 }).onComplete = onFadeFinished;
        }
        
        public function onStartFadeOut(timer:Timer):void
        {
            onReset();
            exit();
        }

        public function onFadeFinished(tween:Tween):void
        {
            removeChild(_fadeToBlack, true);
            _fadeToBlack = null;
            
            removeChild(_gameOver, true);
            _gameOver = null;
            
            super.exit();
        }
    }
}