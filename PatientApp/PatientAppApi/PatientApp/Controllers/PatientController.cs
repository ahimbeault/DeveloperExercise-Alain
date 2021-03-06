﻿using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using PatientApp.Models;
using PatientApp.Services;

namespace PatientApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PatientController : Controller
    {
        #region Private Variables
        private readonly PatientService _patientService;
        #endregion
        #region Constructors

        public PatientController(PatientService patientService, PhoneService phoneService)
        {
            _patientService = patientService;
        }
        #endregion
        #region Public Methods
        [HttpGet]
        public ActionResult<List<Patient>> Get([FromQuery] PatientFilter filter)
        {
            List<Patient> patients = null;
            ActionResult retval = BadRequest(patients);

            try
            {
                patients = _patientService.GetPatients(filter);

                if (patients != null)
                {
                    retval = new OkObjectResult(patients);
                }

            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return retval;
        }

        [HttpPost]
        public ActionResult<string> Post([FromBody] Patient patient)
        {
            ActionResult retval = BadRequest(patient);

            try
            {
                if (_patientService.AddPatient(patient))
                {
                    retval = new OkObjectResult(patient);
                }

            }
            catch(Exception e)
            {
                Console.Write(e);
            }


            return retval;
        }

        [HttpPut]
        public ActionResult<string> Put([FromBody] Patient patient)
        {
            ActionResult retval = BadRequest(patient);

            try
            {
                if(patient != null)
                {
                    if(_patientService.UpdatePatient(patient))
                    {
                        retval = new OkObjectResult(patient);
                    }
                }

            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return retval;
        }

        [HttpDelete("{patientId}")]
        public ActionResult<string> Delete(Guid patientId)
        {
            ActionResult retval = BadRequest(patientId);

            try
            {
                if(_patientService.DeletePatient(patientId))
                {
                    retval = new OkObjectResult(patientId);
                }
            }
            catch(Exception e)
            {
                Console.Write(e);
            }

            return retval;
        }
        #endregion

    }
}
