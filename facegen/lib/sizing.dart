class ContextSize{
  double pad = 0, halfWidth = 0, width = 0, height = 0, w = 0, h = 0, titleFont = 0, textFont = 0;

  ContextSize(){
    pad = 0;
    halfWidth = 0;
    width = 0;
    height = 0;
    w = 0;
    h = 0;
    titleFont = 0;
    textFont = 0;
  }

  void setPad(double pad){
    this.pad = pad;
  }
  void setHalfWidth(double halfWidth){
    this.halfWidth = halfWidth;
  }
  void setWidth(double width){
    this.width = width;
  }
  void setHeight(double height){
    this.height = height;
  }
  void setW(double w){
    this.w = w;
  }
  void setH(double h){
    this.h = h;
  }
  void setTitleFont(double titleFont){
    this.titleFont = titleFont;
  }
  void setTextFont(double textFont){
    this.textFont = textFont;
  }

  double getPad(){
    return this.pad;
  }
  double getHalfWidth(){
    return this.halfWidth;
  }
  double getWidth(){
    return this.width;
  }
  double getHeight(){
    return this.height;
  }
  double getW(){
    return this.w;
  }
  double getH(){
    return this.h;
  }
  double getTitleFont(){
    return this.titleFont;
  }
  double getTextFont(){
    return this.textFont;
  }


}