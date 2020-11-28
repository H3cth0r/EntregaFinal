vertices = [0, 1.5, 0;3, 1.5, 0;3 ,1.5, 4;0, 1.5, 4;]; 
faces = [1, 2, 3, 4]; % face #1
vertices2 =[1.5, 0, 0; 1.5, 3, 0; 1.5, 3, 4; 1.5, 0, 4];
faces2 =[1, 2, 3, 4];

hojas1 = patch('Faces', faces, 'Vertices', vertices, 'FaceColor', 'g');
hojas2 = patch('Faces', faces2, 'Vertices', vertices2, 'FaceColor', 'g');


xlabel('x'); ylabel('y'); zlabel('z');
axis vis3d equal;
view([142.5, 30]);
camlight;