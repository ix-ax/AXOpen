// axosimple
// Copyright (c)2024 Peter Kurhajec and Contributors All Rights Reserved.
// Contributors: https://github.com/PTKu/ix/graphs/contributors
// See the LICENSE file in the repository root for more information.
// https://github.com/PTKu/ix/blob/master/LICENSE
// Third party licenses: https://github.com/PTKu/ix/blob/master/notices.md

using axosimple.server.Units;

namespace axosimple.BaseUnit
{
    public partial class Unit : AXOpen.Core.AxoObject, axosimple.IUnit
    {
        public IUnitServices UnitServices { get; internal set; }
    }
}