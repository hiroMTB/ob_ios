#include "Voro.h"

void Voro::clear(){
    vPs.clear();
    vD.clear();
}

void Voro::addVertices(const vector<glm::vec2> & pos){
    // add vertices
    for(int i=0; i<pos.size(); i++){
        vPs.push_back(vPoint(pos[i].x, pos[i].y));
    }
}

void Voro::create(){
    vD.clear();
    boost::polygon::construct_voronoi(vPs.begin(), vPs.end(), &vD);
}

void Voro::draw(){
    if( 1 ){
        ofSetLineWidth(1);
        voronoi_diagram<double>::const_cell_iterator it = vD.cells().begin();
        for (; it!= vD.cells().end(); ++it) {
            
            const cell_type& cell = *it;
            const edge_type* edge = cell.incident_edge();
            
            do{
                if(edge->is_primary()){
                    if( edge->is_finite() ){
                        if (edge->cell()->source_index() < edge->twin()->cell()->source_index()){
                            float x0 = edge->vertex0()->x();
                            float y0 = edge->vertex0()->y();
                            float x1 = edge->vertex1()->x();
                            float y1 = edge->vertex1()->y();
                            
                            float limity = 800;
                            float limitx = 4000;
                            bool xOver = ( abs(x0)>limitx || abs(x1)>limitx );
                            bool yOver = ( abs(y0)>limity || abs(y1)>limity );
                            
                            bool draw = 1; //!xOver && !yOver;
                            
                            ofSetColor(0,0,0, 100);
                            
                            if(draw){
                                ofDrawLine(x0,y0,0,x1,y1,0);
                            }else{
                                if( ofRandom(0.0, 1.0)>0.9){
                                    ofSetColor(0.5, 0.5, 0.5, 0.5);
                                    ofDrawLine(x0,y0,0,x1,y1,0);
                                }
                            }
                        }
                    }else{
                        if( 0 ){
                            const vertex_type * v0 = edge->vertex0();
                            if( v0 ){
                                vPoint p1 = vPs[edge->cell()->source_index()];
                                vPoint p2 = vPs[edge->twin()->cell()->source_index()];
                                float x0 = edge->vertex0()->x();
                                float y0 = edge->vertex0()->y();
                                float end_x = (p1.y() - p2.y()) * ofGetWidth();
                                float end_y = (p1.x() - p2.x()) * -ofGetWidth();
                                ofDrawLine(x0,y0,0,end_x,end_y,0);
                            }
                        }
                    }
                }
                edge = edge->next();
            }while (edge != cell.incident_edge());
        }
    }
    
    // draw Point
    if( 0 ){
        glPointSize(3);
        ofSetColor(255, 0,0);
        for( auto v : vPs ){
            ofDrawCircle(v.x(), v.y(), 2);
        }
    }
    
}
