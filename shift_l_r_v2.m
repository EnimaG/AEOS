function [overp_VTWs, decesion] = shift_l_r_v2(overp_VTWs, rr)

%rr is the VTW vertecis
%rr 1 is the time
%rr 2 is the rollf the high pririty tasks that split the curent
%tasks VYW
%rr 3 is the pitchf the high pririty tasks that split the curent
%tasks VYW
%rr 4 is the task duration of the high pririty tasks that split the curent
%tasks VYW

%initilizin------------------------------------------------
        roll = overp_VTWs{12};
        pitch = overp_VTWs{13};
        task_dur = datenum(0, 0, 0, 0, 0, overp_VTWs{5});
        otw(1) = overp_VTWs{4};
        otw(2) = overp_VTWs{16};
        otw(3) = overp_VTWs{12};
        otw(4) = overp_VTWs{13};
        decesion = 0;
        overp_VTWs{15} = rr;
%------------------------------------------------------------      
        % Calculate 'mid_task' the time at the center of the curent task
        mid_task = otw(1) + (task_dur/2);
        % Calculate the absolute difference between 'rr' and 'mid_task'
        yy = abs(rr(1,:) - mid_task);

        while ~isempty(yy)
            [~, idx_min] = min(yy);
            cc = mod(idx_min, 2);
            % the curent task is close to the end of the VTW segment
            if cc == 0
                    % test if the curent OTW need a shift to another
                    % vertice or just an adjustment in the curent vertice
                    if otw(2) < rr(1,idx_min) && otw(1) > rr(1,idx_min -1)
                        if rr(2,idx_min) ~= inf
                            %[tran_time_1, r, p] = sequentialSearch_0(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min-1), task_dur);
                            [tran_time_1, r, p] = dichotomousSearch_0(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min-1), task_dur);
                            %[tran_time_2,r,p] = exponentialSearch_0(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min-1), task_dur);
                            %fprintf('%f %f %f\n', tran_time_0,tran_time_1,tran_time_2)
                            if   tran_time_1 == -1 
                                s=-1;
                            elseif tran_time_1 == inf || rr(1,idx_min) - datenum(0, 0 , 0 , 0, 0, tran_time_1) >= otw(2)
                                e = otw(2);
                                s = otw(1);
                            else
                                e = rr(1,idx_min) - datenum(0, 0 , 0 , 0, 0, tran_time_1);
                                s = e - task_dur;
                                %update angles
                                %[r, p] = Update_angles(overp_VTWs{7}, e - (task_dur/2));
                                roll = r;
                                pitch = p;
                            end
                        else
                            s = otw(1);
                            e = otw(2);
                            tran_time_1 = nan;
                        end
                        if tran_time_1~=-1
                            if s > rr(1,idx_min - 1)
                            if rr(2,idx_min -1) ~= inf
                                maneuver_poss  = transition_time_check_v2(rr(2,idx_min -1), rr(3, idx_min -1), roll, pitch, rr(1,idx_min -1), s);
                                if ~strcmp(maneuver_poss,'false')
                                    maneuver_2 = 'possible';
                                    maneuver_1 = 'possible';
                                else
                                    maneuver_2 = 'not_possible';
                                    maneuver_1 = 'not_possible';
                                end
                            else
                                maneuver_2 = 'possible';
                                maneuver_1 = 'possible';
                            end
                            else
                            maneuver_2 = 'not_possible';
                            maneuver_1 = 'not_possible';
                            end
                        else
                            maneuver_2 = 'not_possible';
                            maneuver_1 = 'not_possible';
                        end
                    else
                        if rr(2,idx_min) ~= inf
                            %first we need to update the angle at the
                            %shifted min vtw segment time
                            %[tran_time_1,r,p] = sequentialSearch_0(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min-1), task_dur);
                            [tran_time_1, r, p] = dichotomousSearch_0(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min-1), task_dur);
                            %[tran_time_2,r,p] = exponentialSearch_0(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min-1), task_dur);
                            %fprintf('%f %f %f\n', tran_time_0,tran_time_1,tran_time_2)

                            if tran_time_1 == -1
                                s=-1;
                            elseif tran_time_1 == inf 
                               if otw(2) <= rr(1,idx_min) + rr(4,idx_min)
                                   e = otw(2);
                                   s = otw(1);
                               else
                                   e = rr(1,idx_min) + rr(4,idx_min);
                                   s = e - task_dur;
                                   %update angles
                                   %[~, r, p] = Update_angles(overp_VTWs{7}, e - (task_dur/2));
                                   roll = r;
                                   pitch = p;
                               end
                            else
                                e = rr(1,idx_min) - tran_time_1;
                                s = e - task_dur;
                                %update angles
                                %[~, r, p] = Update_angles(overp_VTWs{7}, e - (task_dur/2));
                                roll = r;
                                pitch = p;
                            end
                        else
                            e = rr(1,idx_min);
                            s = e - task_dur;
                            %update angles
                            [r, p] = Update_angles(overp_VTWs{7}, rr(1,idx_min) - (task_dur/2));
                            roll = r;
                            pitch = p;
                            tran_time_1 = nan;
                        end
                      if tran_time_1~=-1
                        if s > rr(1,idx_min - 1)
                            if rr(2,idx_min -1) ~= inf
                                maneuver_poss  = transition_time_check_v2(rr(2,idx_min -1), rr(3, idx_min -1), roll, pitch, rr(1,idx_min -1), s);
                                if ~strcmp(maneuver_poss,'false')
                                    maneuver_2 = 'possible';
                                    maneuver_1 = 'possible';
                                else
                                    maneuver_2 = 'not_possible';
                                    maneuver_1 = 'not_possible';
                                end
                            else
                                maneuver_2 = 'possible';
                                maneuver_1 = 'possible';
                            end
                        else
                            maneuver_2 = 'not_possible';
                            maneuver_1 = 'not_possible';
                        end
                      else
                          maneuver_2 = 'not_possible';
                          maneuver_1 = 'not_possible';
                      end
                    end
                    %remove the curent segment
                    if strcmp('possible', maneuver_1) && strcmp('possible', maneuver_2)
                        overp_VTWs{4} = s;
                        overp_VTWs{16} = e;
%                         overp_VTWs{15} = rr;
                        overp_VTWs{12} = roll;
                        overp_VTWs{13} = pitch;
                        decesion = 1;
                        break;
                    else
                        yy(idx_min - 1:idx_min) = [];
                        rr(:,idx_min - 1:idx_min) = [];
                        %overp_VTWs{15} = rr;
                        decesion = 0;
                    end
            % the curent task is close to the start of the VTW segment
            else
                    if  otw(2) < rr(1,idx_min +1) && otw(1) > rr(1,idx_min)
                        if rr(2,idx_min) ~= inf
                            %[tran_time_1, r, p] = sequentialSearch_1(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min+1), task_dur);
                            %[tran_time_1, r, p] = exponentialSearch_1(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min+1), task_dur);
                            [tran_time_1, r, p] = dichotomousSearch_1(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min+1), task_dur);
                            %fprintf('%f %f %f\n', tran_time_0,tran_time_1,tran_time_2)
                            if tran_time_1==-1
                                e=-1;
                            elseif tran_time_1 == inf || rr(1,idx_min) + datenum(0, 0 , 0 , 0, 0, tran_time_1) <= otw(1)
                                e = otw(2);
                                s = otw(1);
                            else
                                s = rr(1,idx_min) + datenum(0, 0 , 0 , 0, 0, tran_time_1);
                                e = s + task_dur;
                                %update angles
                                %[r, p] = Update_angles(overp_VTWs{7}, e - (task_dur/2));
                                roll = r;
                                pitch = p;
                            end
                        else
                            s = otw(1);
                            e = otw(2);
                            tran_time_1 = nan;
                        end
                        if tran_time_1 ~=-1
                            if e < rr(1,idx_min + 1)
                                if rr(2,idx_min +1) ~= inf
                                    maneuver_poss  = transition_time_check_v2(roll, pitch, rr(2,idx_min +1), rr(3,idx_min +1), e, rr(1,idx_min +1));
                                    if ~strcmp(maneuver_poss,'false')
                                        maneuver_2 = 'possible';
                                        maneuver_1 = 'possible';
                                    else
                                        maneuver_2 = 'not_possible';
                                        maneuver_1 = 'not_possible';
                                    end
                                    
                                else
                                    maneuver_2 = 'possible';
                                    maneuver_1 = 'possible';
                                end
                            else
                                maneuver_2 = 'not_possible';
                                maneuver_1 = 'not_possible';
                            end
                        else
                            maneuver_2 = 'not_possible';
                            maneuver_1 = 'not_possible';
                        end
                    else
                        if rr(2,idx_min) ~= inf
                            %first we need to update the angle at the
                            %shifted min vtw segment time
%                             %compute the transition possibility and time
                            %[tran_time_1, r, p] = sequentialSearch_1(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min+1), task_dur);
                            [tran_time_1, r, p] = dichotomousSearch_1(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min+1), task_dur);
                            %[tran_time_2, r, p] = exponentialSearch_1(overp_VTWs{7}, rr(:,idx_min), rr(:,idx_min+1), task_dur);
                            %fprintf('%f %f %f\n', tran_time_0,tran_time_1,tran_time_2);
                            if tran_time_1==-1
                                e=-1;
                            elseif tran_time_1 == inf 
                               if otw(1) >= rr(1,idx_min) - rr(4,idx_min)
                                   e = otw(2);
                                   s = otw(1);
                               else
                                   s = rr(1,idx_min) - rr(4,idx_min);
                                   e = s + task_dur;
                                   %update angles
                                   %[r, p] = Update_angles(overp_VTWs{7}, e - (task_dur/2));
                                   roll = r;
                                   pitch = p;
                               end
                            else
                                s = rr(1,idx_min) + datenum(0, 0 , 0 , 0, 0, tran_time_1);
                                e = s + task_dur;
                                %update angles
                                %[~, r, p] = Update_angles(overp_VTWs{7}, e - (task_dur/2));
                                roll = r;
                                pitch = p;
                            end
                        else
                            s = rr(1,idx_min); 
                            e = s + task_dur;
                            [r, p] = Update_angles(overp_VTWs{7}, e - (task_dur/2));
                            roll = r;
                            pitch = p;
                            tran_time_1 = nan;
                        end
                        if tran_time_1 ~=-1
                            if e < rr(1,idx_min + 1)
                                if rr(2,idx_min +1) ~= inf
                                    maneuver_poss  = transition_time_check_v2(roll, pitch, rr(2,idx_min +1), rr(3,idx_min +1), e, rr(1,idx_min +1));
                                    if ~strcmp(maneuver_poss,'false')
                                        maneuver_2 = 'possible';
                                        maneuver_1 = 'possible';
                                    else
                                        maneuver_2 = 'not_possible';
                                        maneuver_1 = 'not_possible';
                                    end
                                    
                                else
                                    maneuver_2 = 'possible';
                                    maneuver_1 = 'possible';
                                end
                            else
                                maneuver_2 = 'not_possible';
                                maneuver_1 = 'not_possible';
                            end
                        else
                            maneuver_2 = 'not_possible';
                            maneuver_1 = 'not_possible';
                        end
                    end
                    %remove the curent segment
                    if strcmp('possible', maneuver_1) && strcmp('possible', maneuver_2)
                            overp_VTWs{4} = s;
                            overp_VTWs{16} = e;
%                             overp_VTWs{15} = rr;
                            overp_VTWs{12} = roll;
                            overp_VTWs{13} = pitch;
                            decesion = 1;
                            break;
                    else
                            %remove the curent segment
                            yy(idx_min:idx_min + 1) = [];
                            rr(:,idx_min:idx_min + 1) = [];
                            %overp_VTWs{15} = rr;
                            decesion = 0;
                    end
            end
        end
