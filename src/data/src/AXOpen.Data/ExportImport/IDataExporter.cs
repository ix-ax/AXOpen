﻿using AXOpen.Base.Data;
using AXSharp.Connector;
using Microsoft.AspNetCore.Components.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace AXOpen.Data
{
    public interface IDataExporter<TPlain, TOnline> where TOnline : IAxoDataEntity
    where TPlain : Pocos.AXOpen.Data.IAxoDataEntity
    {
        /// <summary>
        /// Export data from the repository.
        /// </summary>
        /// <param name="dataRepository">Repository for export.</param>
        /// <param name="path">Path to exported direcotry.</param>
        /// <param name="fragmentName">Name of the fragment.</param>
        /// <param name="expression">Expression of function for export rules.</param>
        /// <param name="separator">Separator for individual records.</param>
        void Export(IRepository<TPlain> dataRepository, string path, string fragmentName, Expression<Func<TPlain, bool>> expression, Dictionary<string, bool> customExportData = null, eExportMode exportMode = eExportMode.First, int firstNumber = 50, int secondNumber = 100, char separator = ';');

        /// <summary>
        /// Import data from file to the repository.
        /// </summary>
        /// <param name="dataRepository">Repository for import.</param>
        /// <param name="path">Path to imported direcotry.</param>
        /// <param name="fragmentName">Name of the fragment.</param>
        /// <param name="authenticationState">Authentication state.</param>
        /// <param name="crudDataObject">Object type of the imported records.</param>
        /// <param name="separator">Separator for individual records.</param>
        void Import(IRepository<TPlain> dataRepository, string path, string fragmentName, AuthenticationState authenticationState, ITwinObject crudDataObject = null, char separator = ';');

        /// <summary>
        /// Get name of the exporter.
        /// </summary>
        /// <returns>Name</returns>
        static abstract string GetName();
    }    
}
