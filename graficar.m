function graficar(i,d,block_position,eulerAngles,detectionState)

  L=2; % largo del sensor
           eulerAngles(3)=eulerAngles(3)-1.57; %aguste de sensor 180 grados
           x1=block_position(1); y1=block_position(2);  %posicion en x y y del carro
           x2=x1+L*cos(eulerAngles(3)); y2 = y1+L*sin(eulerAngles(3)); % posicion y orientación del sensor
           x3=x1+d*cos(eulerAngles(3)); y3 = y1+d*sin(eulerAngles(3)); % posicion de la pared 
           hold on 
           subplot(2,1,1)
           title('Distance Sensor')
           hold on 
           plot(i,d,'.')
           pause(.01)
           subplot(2,1,2)
          % xy1 == car position xy2 == car oritentation xy3 == walls
          % plot(x1,y1,'o')
          % plot([x1 x2],[y1 y2]);
           title('Detected Walls') 
           axis([-10 10 -10 10])
          if detectionState ==1
           hold on
           plot(x3,y3,'*')
          end