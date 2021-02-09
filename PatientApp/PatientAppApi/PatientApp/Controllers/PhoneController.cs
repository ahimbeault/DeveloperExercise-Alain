using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using PatientApp.Models;
using PatientApp.Services;

namespace PatientApp.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class PhoneController : Controller
    {
        #region Private Variables
        private readonly PhoneService _phoneService;
        #endregion
        #region Constructors
        public PhoneController(PhoneService phoneService)
        {
            _phoneService = phoneService;
        }
        #endregion
        #region Public Methods
        [HttpGet("{patientId}")]
        public List<Phone> GetPhonesForPatient(Guid patientId)
        {
            List<Phone> phones = null;
            try
            {
                phones = _phoneService.GetPhonesByPatientId(patientId);
            }
            catch(Exception e)
            {
                Console.Write(e);
            }

            return phones;
        }

        [HttpPost]
        public ActionResult<string> Post([FromBody] Phone phone)
        {
            ActionResult retval = BadRequest(phone);
            try
            {
                if (phone != null)
                {
                    phone.PhoneId = Guid.NewGuid();

                    if(_phoneService.AddPhone(phone))
                    {
                        retval = new OkObjectResult(phone);
                    }
                }
            }
            catch(Exception e)
            {
                Console.Write(e);
            }

            return retval;

        }

        [HttpPut]
        public ActionResult<string> Put([FromBody] Phone phone)
        {
            ActionResult retval = BadRequest(phone);

            try
            {
                if (phone != null)
                {
                    if (_phoneService.UpdatePhone(phone))
                    {
                        retval = new OkObjectResult(phone);
                    }
                }
            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return retval;
        }

        [HttpDelete ("{phoneId}")]
        public ActionResult<string> Delete(Guid phoneId)
        {
            ActionResult retval = BadRequest(phoneId);

            try
            {
                if (_phoneService.Delete(phoneId))
                {
                    retval = new OkObjectResult(phoneId);
                }
            }
            catch (Exception e)
            {
                Console.Write(e);
            }

            return retval;
        }

        #endregion

    }
}
