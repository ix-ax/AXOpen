// axosimple
// Copyright (c)2024 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using AXOpen.Messaging.Static;
using AXSharp.Connector;

namespace axosimple.server.Units;

public interface IUnitServices
{
    AXOpen.Data.AxoDataEntity? Data { get; }

    AXOpen.Data.AxoDataEntity? DataHeader { get; }

    AXOpen.Data.AxoDataExchangeBase? DataManger { get; }

    AXOpen.Data.AxoDataEntity? TechnologySettings { get; }

    AXOpen.Data.AxoDataEntity? SharedTechnologySettings { get; }

    public AxoObject? UnitComponents { get; }
        
    public AxoMessageProvider MessageProvider { get; }
    
    public axosimple.BaseUnit.UnitBase Unit { get; }
    
    ITwinObject[] Associates { get; }
    
    string Link { get; }
    
    string ImageLink { get; }
}