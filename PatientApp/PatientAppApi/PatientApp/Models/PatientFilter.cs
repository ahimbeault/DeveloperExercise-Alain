using System;

namespace PatientApp.Models
{
    public class PatientFilter
    {
        public Guid? patientId { get; set; }
        public bool includeDeleted { get; set; } = false;
        public string search { get; set; }

    }
}
