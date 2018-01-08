

function slurm_job_submit(job_desc, part_list, submit_uid)

    default_time = 4294967294     
    default_memory = 2147483648 -- 2TB

    slurm.log_info("")
    for i=0,2,1 do
        slurm.log_info("---------------------")
    end      
    slurm.log_info("-- Job description --")
    

    -- Parameters check
    if not (job_desc.time_limit == nil) then
        if (job_desc.time_limit >= default_time) then
            slurm.log_info("time_limit not specified")
            job_desc.time_limit = 60
        else
            slurm.log_info("time_limit %d", job_desc.time_limit)
        end
    end
     
    if not (job_desc.pn_min_memory == nil) then
        if (job_desc.pn_min_memory >= default_memory) then  
            slurm.log_info("pn_min_memory not specified")
            job_desc.pn_min_memory = 1024
        else
            slurm.log_info("pn_min_memory %s", job_desc.pn_min_memory)
        end
    end
      
    

    slurm.log_info("time_limit %d", job_desc.time_limit)
    slurm.log_info("pn_min_memory %s", job_desc.pn_min_memory)
    -- Classify the job        
    job_desc.qos = classify_job (job_desc.time_limit, job_desc.pn_min_memory)
    slurm.log_info ("Job classify in qos %s", job_desc.qos)

      
     for i=0,2,1 do
       slurm.log_info("----------------------")
     end
     slurm.log_info("")
      
    return slurm.SUCCESS 

end 
 

function classify_job (time, memory) 
    -- QOS list
    -- 1) qos1    --> 100%
    -- 2) qos2    --> 80%
    -- 3) qos3    --> 70%
    -- 4) qos4    --> 50%
    -- 5) qos5    --> 40% 
    -- 6) special --> 100% 
   
    -- Use case 
    --  1) job.mem < 4G     job.time < 2h    --> qos1 
    --  2) job.mem < 8G     job.time < 2h    --> qos1
    --  3) job.mem < 16G    job.time < 2h    --> qos1 
    --  4) job.mem < 32G    job.time < 2h    --> qos1
    --  5) job.mem < 64G    job.time < 2h    --> qos1
    --  6) job.mem < 122G   job.time < 2h    --> qos3
    --
    --  7) job.mem < 4G     job.time < 168h  --> qos2
    --  8) job.mem < 8G     job.time < 168h  --> qos2
    --  9) job.mem < 16G    job.time < 168h  --> qos2
    -- 10) job.mem < 32G    job.time < 168h  --> qos2 
    -- 11) job.mem < 64G    job.time < 168h  --> qos3
    -- 12) job.mem < 122G   job.time < 168h  --> qos4
    --
    -- 13) job.mem < 4G     job.time < 2232h --> qos4 
    -- 14) job.mem < 8G     job.time < 2232h --> qos4
    -- 15) job.mem < 16G    job.time < 2232h --> qos4
    -- 16) job.mem < 32G    job.time < 2232h --> qos4 
    -- 17) job.mem < 64G    job.time < 2232h --> qos4 
    -- 18) job.mem < 122G   job.time < 2232h --> qos5

    -- Job shorter than 2 hours
    if (memory <= 4096) and (time <= 120) then
        return "qos1"
    end
    
    if (memory <= 8192) and (time <= 120) then
        return "qos1"
    end
    
    if (memory <= 16384) and (time <= 120) then
        return "qos1"
    end

    if (memory <= 32768) and (time <= 120) then
        return "qos1"
    end

    if (memory <= 65536) and (time <= 120) then
        return "qos1"
    end
    
    if (memory <= 124928) and (time <= 120) then
        return "qos3"
    end

    -- Job shorter than one week
    if (memory <= 4096) and (time <= 10080) then
        return "qos2"
    end
    
    if (memory <= 8192) and (time <= 10080) then
        return "qos2"
    end
    
    if (memory <= 16384) and (time <= 10080) then
        return "qos2"
    end

    if (memory <= 32768) and (time <= 10080) then
        return "qos2"
    end

    if (memory <= 65536) and (time <= 10080) then
        return "qos3"
    end
    
    if (memory <= 124928) and (time <= 10080) then
        return "qos4"
    end

    -- Job shorter than 84 days
    if (memory <= 4096) and (time <= 120960) then
        return "qos4"
    end
    
    if (memory <= 8192) and (time <= 120960) then
        return "qos4"
    end
    
    if (memory <= 16384) and (time <= 120960) then
        return "qos4"
    end

    if (memory <= 32768) and (time <= 120960) then
        return "qos4"
    end

    if (memory <= 65536) and (time <= 120960) then
        return "qos4"
    end
    
    if (memory <= 124928) and (time <= 120960) then
        return "qos5"
    end

    return "none"
end


function slurm_job_modify(job_desc, job_rec, part_list, modify_uid) 
        return slurm.SUCCESS 
end 

slurm.log_info("LUA/JobSubmit :: initialized") 
return slurm.SUCCESS 
