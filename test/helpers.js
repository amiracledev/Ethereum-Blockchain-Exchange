export const EVM_REVERT = 'VM Exception while pro essing transaction: revert'
export const tokens = (n) => {
	return new web3.utils.BN(
		web3.utils.toWei(n.toString(), 'ether')
		)
};