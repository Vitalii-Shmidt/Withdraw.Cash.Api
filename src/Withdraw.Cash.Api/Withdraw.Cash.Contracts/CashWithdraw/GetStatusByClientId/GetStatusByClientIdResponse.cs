﻿using Withdraw.Cash.Contracts.CashWithdraw.GetStatusByWithdrawRequestId;

namespace Withdraw.Cash.Contracts.CashWithdraw.GetStatusByClientId;
public record GetStatusByClientIdResponse(GetStatusByWithdrawRequestIdResponse[] WithdrawRequests);
