#include "pixelinstrument.h"
#include "../drawingboard.h"
#include <QPen>
#include <QPainter>

PixelInstrument::PixelInstrument(QObject *parent) :
    AbstractInstrument(parent)
{

}

void PixelInstrument::mousePressEvent(QMouseEvent *event, DrawingBoard &board)
{
    if(event->button() == Qt::LeftButton) {
        mStartPoint = mEndPoint = event->pos();
        board.setIsInPaint(true);
    }
}

void PixelInstrument::mouseMoveEvent(QMouseEvent *event, DrawingBoard &board)
{
    if(board.isInPaint()) {
        mEndPoint = event->pos();
        draw(board);
        mStartPoint = event->pos();
    }
}

void PixelInstrument::mouseReleaseEvent(QMouseEvent *event, DrawingBoard &board)
{
    if(board.isInPaint()) {
        mEndPoint = event->pos();
        draw(board);
        board.setIsInPaint(false);
    }
}

void PixelInstrument::draw(DrawingBoard &board)
{
    QPainter painter(board.getImage());

    painter.setPen(QPen(Qt::black));

    if(mStartPoint != mEndPoint)
    {
        painter.drawLine(mStartPoint, mEndPoint);
    }

    if(mStartPoint == mEndPoint)
    {
        painter.drawPoint(mStartPoint);
    }

    painter.end();

    board.update();
}