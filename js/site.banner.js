/**
  * @file   : common.css
  * @author : [story]
  * @brief  : 硫붿씤 �섎떒 愿��⑥궗�댄듃 濡ㅻ쭅
  **/

/**----------------------------------------------------------------------------------------------------------------------------
 * @authro : Shin-HyunHo
 *
 * up.down.left,right 濡ㅻ쭅 �ㅽ겕由쏀듃
 *
 * 媛앹껜�앹꽦 -> var roll = new hh_rolling('rolling'); , var roll = new hh_rolling(document.getElementById('rolling'));
 * roll.set_direction(4);                   // 諛⑺뼢�⑦꽩 ( 1->up,2->right,3->down,4->left )
 * roll.move_gap = 1;                       // ��吏곸씠�� �쎌��⑥쐞
 * roll.time_dealy = 10;                    // ��吏곸씠�� �띾룄
 * roll.time_dealy_pause = 5000;            // ��吏곸씠�ㅺ� �대떦�쒓컙�� �섎㈃ �쒕젅�� 珥덈떒��
 * roll.start();                            // 濡ㅻ쭅 �쒖옉
 * roll.move_up();                          // 濡ㅻ쭅 up
 * roll.move_right();                       // 濡ㅻ쭅 right
roll.move_down();                           // 濡ㅻ쭅 down
roll.move_left();                           // 濡ㅻ쭅 left
roll.direction = {諛⑺뼢�レ옄}
roll.mouseover_pause = true , false         // �좎떆硫덉땄
-------------------------------------------------------------------------------------------------------------------------------- */

var stopchk;
var hh_rolling = function(box){
    if(box.nodeType==1){this.box = box;}
    else {this.box = document.getElementById(box);}
    this.is_rolling         = false;
    this.mouseover_pause    = true;
    this.direction          = 1;
    this.children           = null;
    this.move_gap           = 1;
    this.time_dealy         = 20;
    this.time_dealy_pause   = 0;
    this.time_timer         = null;
    this.time_timer_pause   = null;
    this.intervalcheck      = false;
    this.mouseover          = false;
    this.move_exp           = false;
    this.init();
    this.set_direction(this.direction);
}
hh_rolling.prototype.init = function() {
    this.box.style.position='';
    this.box.style.overflow='hidden';
    var children = this.box.childNodes;
    for(var i=(children.length-1);0<=i;i--){
        if(children[i].nodeType==1) {
            children[i].style.position='relative';
        }
        else {
            this.box.removeChild(children[i]);
        }
    }
    var thisC=this;
    this.box.onmouseover=this.box.onactivate=function() {
        if(!thisC.mouseover_pause) {
            return;
        }
        thisC.mouseover=true;
        if(!thisC.time_timer_pause) {
            thisC.pause();
        }
    }
    this.box.onmouseout=this.box.onbeforedeactivate=function() {
        if(!thisC.mouseover_pause) {
            return;
        }
        thisC.mouseover=false;
        if(!thisC.time_timer_pause) {
            thisC.resume();
        }
    }
}
hh_rolling.prototype.set_direction = function(direction) {
    this.direction=direction;
    if(this.direction==2 ||this.direction==4) {
            this.box.style.whiteSpace='nowrap';
    }
    else {
            this.box.style.whiteSpace='normal';
    }
    var children = this.box.childNodes;
    for(var i=(children.length-1);0<=i;i--) {
            if(this.direction==1) {
                children[i].style.display='block';
            }
            else if(this.direction==2) {
                children[i].style.textlign='right';
                children[i].style.display='inline';
            }
            else if(this.direction==3) {
                children[i].style.display='block';
            }
            else if(this.direction==4) {
                children[i].style.display='inline';
            }
    }
    this.init_element_children();
}
hh_rolling.prototype.init_element_children = function() {
    var children = this.box.childNodes;
    this.children = children;
    for(var i=(children.length-1);0<=i;i--) {
        if(this.direction==1) {
            children[i].style.top='0px';
        }
        else if(this.direction==2) {
            children[i].style.left='-'+this.box.firstChild.offsetWidth+'px';
        }
        else if(this.direction==3) {
            children[i].style.top='-'+this.box.firstChild.offsetHeight+'px';
        }
        else if(this.direction==4) {
            children[i].style.left='0px';
        }
    }
}
hh_rolling.prototype.act_move_up = function() {
    for(var i=0,m=this.children.length;i<m;i++){
        var child = this.children[i];
        child.style.top=(parseInt(child.style.top)-this.move_gap)+'px';
    }
    try{
        if((this.children[0].offsetHeight+parseInt(this.children[0].style.top))<=0) {
            this.box.appendChild(this.children[0]);
            this.init_element_children();
            this.pause_act();
        }
    }catch(e){}
}
hh_rolling.prototype.move_up = function(){
    if(this.direction!=1&&this.direction!=3) {
        return false;
    }
    this.box.appendChild(this.children[0]);
    this.init_element_children();
    this.pause_act();
}

hh_rolling.prototype.act_move_down = function() {
    for(var i=0,m=this.children.length;i<m;i++) {
        var child = this.children[i];
        child.style.top=(parseInt(child.style.top)+this.move_gap)+'px';
    }
    if(parseInt(this.children[0].style.top)>=0) {
        this.box.insertBefore(this.box.lastChild,this.box.firstChild);
        this.init_element_children();
        this.pause_act();
    }
}
hh_rolling.prototype.move_down = function() {
    if(this.direction!=1&&this.direction!=3) {
        return false;
    }
    this.box.insertBefore(this.box.lastChild,this.box.firstChild);
    this.init_element_children();
    this.pause_act();
}
hh_rolling.prototype.act_move_left = function() {
    for(var i=0,m=this.children.length;i<m;i++) {
        var child = this.children[i];
        child.style.left=(parseInt(child.style.left)-this.move_gap)+'px';
    }

    if((this.children[0].offsetWidth+parseInt(this.children[0].style.left))<=0) {
    //if((this.children[0].offsetWidth+parseInt(this.children[0].style.left))==100) {
        this.box.appendChild(this.box.firstChild);
        this.init_element_children();
        this.pause_act();
    }
}
hh_rolling.prototype.move_left = function() {
    if(this.direction!=2&&this.direction!=4) {
        return false;
    }
    this.box.appendChild(this.box.firstChild);
    this.init_element_children();
    this.pause_act();
}
hh_rolling.prototype.act_move_right = function() {
    for(var i=0,m=this.children.length;i<m;i++) {
        var child = this.children[i];
        child.style.left=(parseInt(child.style.left)+this.move_gap)+'px';
    }
    if(parseInt(this.box.lastChild.style.left)>=0) {
        this.box.insertBefore(this.box.lastChild,this.box.firstChild);
        this.init_element_children();
        this.pause_act();
    }
}
hh_rolling.prototype.move_right = function() {
    if(this.direction!=2&&this.direction!=4) {
        return false;
    }
    this.box.insertBefore(this.box.lastChild,this.box.firstChild);
    this.init_element_children();
    this.pause_act();
}
hh_rolling.prototype.autostart = function() {
    this.set_direction(4);
    this.move_gap = 1;
    this.time_dealy = 20;
    this.time_dealy_pause = 0;
    this.start();
}
hh_rolling.prototype.start = function() {
    var thisC = this;
    this.stop();
    this.is_rolling = true;
    var act = function(){
        if(thisC.is_rolling){
            if(thisC.direction==1){
                thisC.act_move_up();
            }
            else if(thisC.direction==2){
                thisC.act_move_right();
            }
            else if(thisC.direction==3){
                thisC.act_move_down();
            }
            else if(thisC.direction==4){
                thisC.act_move_left();
            }
        }
    }
    this.time_timer = setInterval(act,this.time_dealy);
}
hh_rolling.prototype.pause_act = function() {
    if(this.time_dealy_pause){
        var thisC = this;
        var act = function(){thisC.resume();thisC.time_timer_pause=null;}
        if(this.time_timer_pause){clearTimeout(this.time_timer_pause);}
        this.time_timer_pause = setTimeout(act,this.time_dealy_pause);
        this.pause();
    }
}
hh_rolling.prototype.pause = function() {
    this.is_rolling = false;
}
hh_rolling.prototype.resume = function() {
    if(!this.mouseover){
        this.is_rolling = true;
    }
}
hh_rolling.prototype.stop = function() {
    this.is_rolling = false;
    //if(!this.time_timer){
        clearInterval(this.time_timer);
    //}
    this.time_timer = null;

    stopchk = true;
}

function rolling_start() {
    if ($('#bannerList>li').length > 7) {
        banner.set_direction(4);
        banner.move_gap = 1;
        banner.time_dealy = 20;
        banner.time_dealy_pause = 0;
        banner.start();

        $('.controler a.pause').show();
        $('.controler a.play').hide();
    }
}
function rolling_stop() {
    banner.stop();
    $('.controler a.pause').hide();
    $('.controler a.play').show();
}
function rolling_prev() {
    banner.set_direction(2);
    if(stopchk == true){
        banner.start();
        stopchk == false;
    }
}
function rolling_next() {
    banner.set_direction(4);
    if(stopchk == true){
        banner.start();
        stopchk == false;
    }
}