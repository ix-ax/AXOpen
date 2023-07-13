﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data
{
    public class FragmentData
    {
        public bool Exported { get; set; }
        public Dictionary<string, bool> Data { get; set; }

        public FragmentData(bool exported, Dictionary<string, bool> data)
        {
            Exported = exported;
            Data = data;
        }
    }
}
